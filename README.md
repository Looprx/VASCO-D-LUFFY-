# 💊 VASCO D LUFFY - Drug Safety Platform

A professional medication safety platform that provides comprehensive drug interaction checking, ingredient analysis, and educational resources for healthcare professionals and patients.

## 🎯 Mission

To provide accurate, reliable, and accessible medication safety information to help prevent adverse drug reactions and promote safer medication practices.

## ✨ Key Features

### 🔍 Drug Interaction Checker
- **Real-time Analysis**: Check interactions between multiple medications
- **Severity Levels**: Clear SAFE/CAUTION/AVOID classifications
- **Comprehensive Database**: 40+ Indian medications and 50+ ingredients
- **Professional Recommendations**: Evidence-based safety advice

### 📚 Ingredient Database
- **Active & Inactive Ingredients**: Complete ingredient profiles
- **Purpose & Usage**: Detailed explanations of ingredient functions
- **Side Effects**: Comprehensive adverse reaction information
- **Safety Considerations**: Special population warnings

### 🎓 Educational Resources
- **Expert Articles**: In-depth medication safety guides
- **Real-life Cases**: Learn from actual interaction scenarios
- **Best Practices**: Professional medication management guidelines
- **Latest Research**: Up-to-date pharmaceutical information

### 📱 Modern Interface
- **Responsive Design**: Works seamlessly on all devices
- **Professional UI**: Clean, medical-grade interface
- **Accessibility**: WCAG-compliant design
- **Dark/Light Mode**: Comfortable viewing in any environment

## 🚀 Quick Start

### Development

```bash
# Install dependencies
npm install

# Setup database
npm run setup:db

# Start development server
npm run dev

# Open http://localhost:3000
```

### Production Deployment

```bash
# Build for production
npm run build

# Start production server
npm start

# Or use deployment scripts
npm run deploy
```

## 📊 Technology Stack

### Core Framework
- **⚡ Next.js 15** - React framework with App Router
- **📘 TypeScript 5** - Type-safe development
- **🎨 Tailwind CSS 4** - Modern styling
- **🧩 shadcn/ui** - Professional UI components

### Backend & Database
- **🗄️ Prisma** - Database ORM
- **💾 SQLite** - Lightweight database (easily upgradeable to PostgreSQL)
- **🔌 Socket.IO** - Real-time features
- **📡 API Routes** - RESTful API endpoints

### State & Data Management
- **🐻 Zustand** - Client state management
- **🔄 TanStack Query** - Server state management
- **🎣 React Hook Form** - Form handling
- **✅ Zod** - Schema validation

### Professional Features
- **🎨 Framer Motion** - Smooth animations
- **📊 Recharts** - Data visualization
- **🌈 Next Themes** - Theme management
- **🖼️ Sharp** - Image optimization

## 🏗️ Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── api/               # API routes
│   │   ├── interactions/  # Drug interaction checker
│   │   ├── medications/   # Medication data
│   │   ├── ingredients/   # Ingredient data
│   │   └── health/        # Health check
│   ├── education/         # Educational content
│   ├── database/          # Database browser
│   ├── contact/           # Contact form
│   └── add-medicine/      # Add new medicine
├── components/            # React components
│   ├── ui/               # shadcn/ui components
│   ├── lazy-image.tsx    # Optimized images
│   ├── mobile-nav.tsx    # Mobile navigation
│   └── theme-toggle.tsx  # Theme switcher
├── hooks/                # Custom React hooks
│   ├── use-api.ts        # API client
│   ├── use-debounce.ts   # Debounced search
│   ├── use-mobile.ts     # Mobile detection
│   └── use-toast.ts      # Toast notifications
└── lib/                  # Utilities
    ├── db.ts             # Database client
    ├── socket.ts         # Socket.IO setup
    └── utils.ts          # Helper functions
```

## 🗄️ Database Schema

The platform uses a comprehensive database schema with the following main entities:

- **Medications**: Drug information with categories and descriptions
- **Ingredients**: Active and inactive ingredients with detailed profiles
- **Interactions**: Drug-drug and drug-ingredient interactions with severity levels
- **Educational Posts**: Educational content and articles
- **Contact Messages**: User inquiries and feedback

## 🚀 Deployment Options

### Vercel (Recommended)
```bash
npm i -g vercel
vercel login
vercel --prod
```

### Docker
```bash
docker build -t vascodluffy .
docker run -d -p 3000:3000 vascodluffy
```

### Traditional VPS
```bash
npm run setup:db
npm run build
npm start
```

For detailed deployment instructions, see [DEPLOYMENT.md](./DEPLOYMENT.md) and [QUICK_DEPLOY.md](./QUICK_DEPLOY.md).

## 🔧 Configuration

### Environment Variables

```env
# Database
DATABASE_URL="file:./db/custom.db"

# Application
NODE_ENV="production"
NEXT_PUBLIC_APP_URL="https://your-domain.com"
NEXT_PUBLIC_APP_NAME="VASCO D LUFFY Drug Safety Platform"

# Security
NEXTAUTH_SECRET="your-secret-here"
NEXTAUTH_URL="https://your-domain.com"
```

### Database Setup

```bash
# Initialize database
npm run setup:db

# Generate Prisma client
npm run db:generate

# Push schema changes
npm run db:push
```

## 📋 Features in Detail

### Drug Interaction Checker
- **Multi-drug Analysis**: Check interactions between multiple medications simultaneously
- **Severity Assessment**: Clear visual indicators for SAFE/CAUTION/AVOID levels
- **Detailed Explanations**: Comprehensive information about interaction mechanisms
- **Professional Recommendations**: Evidence-based advice for healthcare providers

### Ingredient Database
- **Comprehensive Profiles**: Detailed information about each ingredient
- **Categorization**: Clear distinction between active and inactive ingredients
- **Safety Information**: Side effects, contraindications, and warnings
- **Usage Guidelines**: Proper administration and storage information

### Educational Resources
- **Expert Content**: Articles written by healthcare professionals
- **Case Studies**: Real-world examples of medication interactions
- **Best Practices**: Guidelines for safe medication use
- **Latest Updates**: Current pharmaceutical research and findings

## 🎨 UI/UX Features

### Professional Design
- **Medical-grade Interface**: Clean, professional appearance suitable for healthcare settings
- **Color-coded Severity**: Visual indicators for interaction severity levels
- **Responsive Layout**: Optimized for desktop, tablet, and mobile devices
- **Accessibility**: WCAG 2.1 compliant design

### Interactive Elements
- **Smooth Animations**: Professional transitions and micro-interactions
- **Real-time Search**: Instant results as you type
- **Lazy Loading**: Optimized performance for large datasets
- **Toast Notifications**: User-friendly feedback system

## 🔒 Security & Privacy

### Data Protection
- **No Personal Data Collection**: Platform doesn't store personal health information
- **Secure API**: Protected endpoints with proper validation
- **HTTPS Only**: Secure communication in production
- **Privacy-focused**: No third-party tracking

### Medical Disclaimer
The platform includes comprehensive medical disclaimers and encourages users to:
- Consult healthcare professionals before making medical decisions
- Verify information with qualified medical practitioners
- Use the platform as a supplementary resource, not medical advice

## 🤝 Contributing

We welcome contributions from healthcare professionals, developers, and researchers. Please see our contributing guidelines for more information.

### Development Guidelines
- Follow TypeScript best practices
- Maintain code quality with ESLint
- Write comprehensive tests
- Update documentation for new features

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 🆘 Support

For technical support, bug reports, or feature requests:
- Check our [documentation](./DEPLOYMENT.md)
- Review existing issues
- Contact our development team

## 🙏 Acknowledgments

- Healthcare professionals who provided medical expertise
- Open-source contributors who made this platform possible
- Pharmaceutical databases and research institutions
- The patient safety community

---

**Built with ❤️ for medication safety and patient care.**

*VASCO D LUFFY - Making medication information accessible and actionable.*