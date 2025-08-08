# VASCO D LUFFY - Vercel Deployment Guide

## 🚀 Deploying to Vercel

This guide will help you deploy the VASCO D LUFFY Drug Safety Platform to Vercel with a working configuration.

## ✅ Prerequisites

- **Node.js** 18.x or higher
- **Git** installed
- **Vercel account** (free tier available)
- **GitHub repository** (recommended)

## 📋 Deployment Steps

### Step 1: Prepare Your Repository

1. **Ensure your code is committed to Git:**
   ```bash
   git add .
   git commit -m "Ready for Vercel deployment"
   git push origin main
   ```

2. **Verify build works locally:**
   ```bash
   npm run build
   ```

### Step 2: Deploy via Vercel CLI

#### Option A: Automatic Deployment (Recommended)

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel:**
   ```bash
   vercel login
   ```

3. **Deploy to Vercel:**
   ```bash
   vercel --prod
   ```

4. **Follow the prompts:**
   - Set up project name
   - Link to your Git repository (recommended)
   - Configure environment variables

#### Option B: Vercel Dashboard

1. **Go to [Vercel Dashboard](https://vercel.com/dashboard)**
2. **Click "New Project"**
3. **Import your Git repository**
4. **Configure project settings**

### Step 3: Configure Environment Variables

In your Vercel project dashboard, go to **Settings** → **Environment Variables** and add:

```env
# Required Variables
NODE_ENV=production
VERCEL=1
NEXT_PUBLIC_VERCEL=1
NEXT_PUBLIC_APP_URL=https://your-app-name.vercel.app
NEXT_PUBLIC_APP_NAME=VASCO D LUFFY Drug Safety Platform

# Security (Generate secure values)
NEXTAUTH_SECRET=your-very-secure-secret-here-min-32-characters
NEXTAUTH_URL=https://your-app-name.vercel.app

# Optional Variables
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=G-XXXXXXXXXX
NEXT_PUBLIC_SENTRY_DSN=https://your-sentry-dsn
ZAI_API_KEY=your-zai-api-key
```

**Important:** Click the "Encrypt" button for sensitive variables like `NEXTAUTH_SECRET`.

### Step 4: Configure Build Settings

In your Vercel project dashboard, go to **Settings** → **Build & Development**:

- **Build Command**: `npm run vercel-build`
- **Output Directory**: `.next`
- **Install Command**: `npm install`

### Step 5: Deploy and Test

1. **Trigger deployment:**
   - Push changes to your repository, or
   - Click "Deploy" in the Vercel dashboard

2. **Wait for deployment to complete**

3. **Test your application:**
   ```bash
   # Test health endpoint
   curl https://your-app-name.vercel.app/api/health
   
   # Test medications endpoint
   curl https://your-app-name.vercel.app/api/medications
   
   # Test interactions endpoint
   curl -X POST https://your-app-name.vercel.app/api/interactions \
     -H "Content-Type: application/json" \
     -d '{"medicationIds": ["1", "2"]}'
   ```

## 🔧 Troubleshooting

### Common Issues

#### 1. Build Fails

**Problem:** Build fails with TypeScript errors

**Solution:**
```bash
# Check TypeScript errors locally
npm run build

# Fix TypeScript errors and commit changes
git add .
git commit -m "Fix TypeScript errors"
git push origin main
```

#### 2. API Routes Return 500 Errors

**Problem:** API endpoints are not working

**Solution:**
- Check environment variables are set correctly
- Verify the build used the correct configuration
- Check Vercel function logs for specific errors

#### 3. Database Not Working

**Problem:** Database-related errors

**Solution:** The platform uses in-memory data for Vercel deployment, which is normal. You should see:
```json
{
  "status": "healthy",
  "database": "vercel-in-memory",
  "medications": 5,
  "ingredients": 3,
  "interactions": 3,
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

#### 4. Styles Not Loading

**Problem:** CSS styles are missing

**Solution:**
- Ensure Tailwind CSS is properly configured
- Check that `next.config.ts` doesn't have conflicting settings
- Verify the build completed successfully

### Advanced Troubleshooting

#### Check Vercel Logs

1. **Go to your Vercel project dashboard**
2. **Click on the "Functions" tab**
3. **Select the function that's failing**
4. **Check the logs for specific error messages**

#### Local Testing with Vercel Environment

To test locally with Vercel environment variables:

```bash
# Install dotenv if not already installed
npm install dotenv

# Create a .env.local file with Vercel variables
echo "VERCEL=1
NEXT_PUBLIC_VERCEL=1
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_APP_NAME=VASCO D LUFFY Drug Safety Platform" > .env.local

# Start development server
npm run dev
```

## 📊 Features Available on Vercel

### ✅ Working Features

1. **Drug Interaction Checker**
   - Real-time interaction analysis
   - Severity level assessment (SAFE/CAUTION/AVOID)
   - Professional recommendations

2. **Medication Database**
   - Browse available medications
   - Search and filter functionality
   - Detailed medication information

3. **Ingredient Database**
   - Active and inactive ingredients
   - Detailed ingredient profiles
   - Safety information

4. **Educational Content**
   - Medical articles and guides
   - Real-life case studies
   - Best practices

5. **Professional UI/UX**
   - Responsive design
   - Dark/light theme support
   - Accessible interface

### ⚠️ Limitations on Vercel

1. **Data Persistence**
   - Uses in-memory database (data resets on deployment)
   - No persistent storage for user-added medications
   - Sample data only

2. **No Real-time Features**
   - Socket.IO removed for Vercel compatibility
   - No live updates or real-time notifications

3. **Limited Admin Features**
   - Cannot persist user-added medications
   - No database management interface

## 🔄 Alternative: Add Persistent Database

For production use with persistent data, consider adding a database:

### Option 1: Vercel Postgres

```sql
-- Add to your Vercel project settings
DATABASE_URL="postgres://user:password@host:port/database"
```

### Option 2: External Database

```sql
-- Use any external PostgreSQL/MySQL database
DATABASE_URL="postgresql://user:password@external-host:port/database"
```

### Option 3: Serverless Database

Consider services like:
- **PlanetScale** (MySQL)
- **Supabase** (PostgreSQL)
- **Neon** (PostgreSQL)

## 📈 Monitoring and Analytics

### Set Up Monitoring

1. **Vercel Analytics**
   - Enabled by default on Vercel
   - Real-time performance metrics
   - User analytics

2. **Error Tracking**
   ```env
   # Add to environment variables
   NEXT_PUBLIC_SENTRY_DSN=https://your-sentry-dsn
   ```

3. **Uptime Monitoring**
   - Use external services like UptimeRobot
   - Monitor health endpoint: `/api/health`

### Performance Optimization

1. **Enable Caching**
   ```javascript
   // Add to API routes for better performance
   export const revalidate = 3600; // 1 hour
   ```

2. **Image Optimization**
   - Already configured in `next.config.ts`
   - Uses Vercel's image optimization

3. **Bundle Analysis**
   - Check bundle size in Vercel dashboard
   - Optimize large dependencies if needed

## 🚀 Post-Deployment Checklist

- [ ] Application loads successfully
- [ ] All API endpoints respond correctly
- [ ] Drug interaction checker works
- [ ] Mobile responsiveness is maintained
- [ ] Dark/light theme works
- [ ] Health endpoint returns proper status
- [ ] No console errors in browser
- [ ] Performance metrics are acceptable
- [ ] Environment variables are properly set
- [ ] Domain is configured correctly

## 🆘 Support

If you encounter issues:

1. **Check Vercel Logs**
   - Functions tab in Vercel dashboard
   - Runtime and build logs

2. **Test Locally**
   ```bash
   npm run build
   npm start
   ```

3. **Community Support**
   - Vercel documentation
   - Next.js GitHub issues
   - Stack Overflow

4. **Contact Development Team**
   - Create GitHub issue with detailed error description
   - Include Vercel deployment logs
   - Specify steps to reproduce the issue

---

**🎉 Your VASCO D LUFFY platform is now ready for Vercel deployment!**

The platform will work with sample data and provide all core functionality for medication safety checking. For production use with persistent data, consider adding a database as described in the alternative section.