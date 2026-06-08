const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');
require('dotenv').config();

// Initialize Firebase Admin SDK
// Make sure to set GOOGLE_APPLICATION_CREDENTIALS path in environment variables
try {
  admin.initializeApp({
    credential: admin.credential.applicationDefault()
  });
  console.log('Firebase Admin SDK initialized successfully.');
} catch (e) {
  console.warn('Firebase application Default Credentials not found. Firebase features will fail in production.');
}

const db = admin.firestore();
const app = express();

// Stripe Configuration
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Middleware
app.use(cors({ origin: true }));
// Use raw parser for Stripe webhooks, standard JSON parser for other routes
app.use((req, res, next) => {
  if (req.originalUrl === '/api/payments/stripe/webhook') {
    next();
  } else {
    express.json()(req, res, next);
  }
});

// Port configuration
const PORT = process.env.PORT || 5000;

// Base route
app.get('/', (req, res) => {
  res.status(200).send('NovaMarket Secure E-Commerce API is active.');
});

/**
 * 1. STRIPE: Create Payment Intent
 * Creates a secure transaction sheet client secret for the client-side checkout.
 */
app.post('/api/payments/stripe/create-payment-intent', async (req, res) => {
  const { amount, currency, orderId } = req.body;

  if (!amount || !currency || !orderId) {
    return res.status(400).json({ error: 'Missing parameters: amount, currency, or orderId' });
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: currency.toLowerCase(),
      metadata: { orderId: orderId }
    });

    res.status(200).json({
      clientSecret: paymentIntent.client_secret,
      id: paymentIntent.id
    });
  } catch (error) {
    console.error('Error creating Stripe PaymentIntent:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * 2. STRIPE: Webhook Listener
 * Prevents client-side payment forgery. Validates transaction success from Stripe servers.
 */
app.post('/api/payments/stripe/webhook', express.raw({ type: 'application/json' }), async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);
  } catch (err) {
    console.error(`Webhook Error: ${err.message}`);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle transaction success event
  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object;
    const orderId = paymentIntent.metadata.orderId;

    try {
      // Securely update order status to processing / paid in Firestore database
      await db.collection('orders').doc(orderId).update({
        status: 'processing',
        paymentStatus: 'paid',
        paymentIntentId: paymentIntent.id,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      console.log(`Order ${orderId} successfully marked as PAID from Stripe webhook.`);
    } catch (e) {
      console.error(`Failed to update order status for ${orderId}:`, e);
    }
  }

  res.json({ received: true });
});

/**
 * 3. RAZORPAY: Verify Payment Signature
 * Validates Razorpay checkout tokens cryptographically.
 */
const crypto = require('crypto');
app.post('/api/payments/razorpay/verify', async (req, res) => {
  const { razorpay_order_id, razorpay_payment_id, razorpay_signature, internalOrderId } = req.body;

  if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature || !internalOrderId) {
    return res.status(400).json({ error: 'Missing payment signature credentials' });
  }

  try {
    const text = razorpay_order_id + "|" + razorpay_payment_id;
    const generated_signature = crypto
      .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET)
      .update(text)
      .digest('hex');

    if (generated_signature === razorpay_signature) {
      // Valid transaction
      await db.collection('orders').doc(internalOrderId).update({
        status: 'processing',
        paymentStatus: 'paid',
        razorpayPaymentId: razorpay_payment_id,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      res.status(200).json({ status: 'success', message: 'Razorpay payment verified successfully' });
    } else {
      res.status(400).json({ status: 'failed', message: 'Cryptographic signature mismatch. Potential tampering.' });
    }
  } catch (error) {
    console.error('Error verifying Razorpay signature:', error);
    res.status(500).json({ error: error.message });
  }
});

// Start Server
app.listen(PORT, () => {
  console.log(`NovaMarket Secure Backend listening on port ${PORT}`);
});
