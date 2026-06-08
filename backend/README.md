# NovaMarket E-Commerce Backend Service

A secure, transaction-safe backend built with Node.js, Express, and Firebase Admin. It manages Stripe & Razorpay payment flows, signature tokenization, and listens to Stripe webhooks to prevent client-side payment forgery.

## Features

1. **Stripe Payment Intent**: Generates secure payment tokens.
2. **Stripe Webhook Listener**: Captures server-to-server transaction successes.
3. **Razorpay Signature Verification**: Validates cryptographic signatures to prevent payment fraud.
4. **Firebase Admin Sync**: Updates Firestore records on payment success.

## Getting Started

### Prerequisites

- Node.js (v16+)
- npm or yarn

### Installation

1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```

### Configurations

Create a `.env` file in the root of the `backend/` directory:

```env
PORT=5000
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
RAZORPAY_KEY_ID=rzp_test_...
RAZORPAY_KEY_SECRET=your_razorpay_secret
```

### Linking Firebase Admin

1. In the Firebase Console, go to **Project Settings** > **Service accounts**.
2. Click **Generate new private key**, then save the JSON file.
3. Set the environment variable:
   - **Windows (PowerShell)**: `$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account-key.json"`
   - **macOS/Linux (Terminal)**: `export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"`

### Running the Server

Start the API in development mode:
```bash
npm run dev
```

The API will be available at `http://localhost:5000`.

---

## API Endpoints Reference

### 1. Stripe Payment Intent
- **Endpoint**: `POST /api/payments/stripe/create-payment-intent`
- **Body**:
  ```json
  {
    "amount": 299.99,
    "currency": "usd",
    "orderId": "your-firestore-order-id"
  }
  ```
- **Response**:
  ```json
  {
    "clientSecret": "pi_123456_secret_654321",
    "id": "pi_123456"
  }
  ```

### 2. Razorpay Verification
- **Endpoint**: `POST /api/payments/razorpay/verify`
- **Body**:
  ```json
  {
    "razorpay_order_id": "order_123",
    "razorpay_payment_id": "pay_123",
    "razorpay_signature": "sha256-signature...",
    "internalOrderId": "your-firestore-order-id"
  }
  ```
