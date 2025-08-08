
preview : https://preview-chat-c049aa80-14e1-47e1-84e3-cc21c73a65f9.space.z.ai/



<img width="3188" height="1202" alt="frame (3)" src="https://github.com/user-attachments/assets/517ad8e9-ad22-457d-9538-a9e62d137cd7" />

#  💊 VASCO D LUFFY - Drug Safety Platform

## Basic Details  
### Project Name: VASCO D LUFFY - Drug Safety Platform  
### Team Name: [Your Team Name Here]

### Team Members
- Team Lead: [Name] - [College]
- Member 2: [Name] - [College]
- Member 3: [Name] - [College]

---

## Project Description  
A professional medication safety platform powered by a modern scaffold (Z.ai), offering comprehensive drug interaction checking, ingredient analysis, and educational tools for safer medication practices.

---

## The Problem (that doesn't exist)  
Medication interaction knowledge is either inaccessible or overly complex for patients and some healthcare providers.

---

## The Solution (that nobody asked for)  
A polished, responsive platform powered by modern technologies that not only checks drug interactions but educates and informs users with accuracy and speed.

---

## Preview  
🌐 [Live Preview](https://preview-chat-c049aa80-14e1-47e1-84e3-cc21c73a65f9.space.z.ai/)

---

## ✨ Key Features

### 🔍 Drug Interaction Checker
- Multi-drug interaction analysis with severity classifications (SAFE / CAUTION / AVOID)
- Comprehensive 40+ Indian drugs & 50+ ingredients database
- Evidence-based professional recommendations

### 📚 Ingredient Database
- Detailed active/inactive ingredient profiles
- Purpose, side effects, and special population warnings

### 🎓 Educational Resources
- Expert articles, real-life case studies, and safety guidelines
- Up-to-date pharmaceutical research

### 📱 Modern Interface
- Medical-grade responsive UI
- WCAG-compliant design with light/dark mode
- Smooth animations and real-time search

---

## 💻 Technical Details

### Software Stack
- **Frameworks**: Next.js 15, Tailwind CSS 4
- **Languages**: TypeScript 5
- **UI**: shadcn/ui, Framer Motion, Lucide React
- **Forms & Validation**: React Hook Form, Zod
- **State/Data**: Zustand, TanStack Query, Axios
- **Auth & DB**: NextAuth.js, Prisma ORM
- **Database**: SQLite (upgradeable to PostgreSQL)
- **Image & Theme**: Sharp, Next Themes

### Real-time & Backend
- **WebSocket**: Socket.IO
- **API**: RESTful endpoints (medications, ingredients, health checks)

---

## 📁 Project Structure

```
src/
├── app/
│   ├── api/
│   │   ├── interactions/
│   │   ├── medications/
│   │   ├── ingredients/
│   │   └── health/
│   ├── education/
│   ├── database/
│   ├── contact/
│   └── add-medicine/
├── components/
│   ├── ui/
│   ├── lazy-image.tsx
│   ├── mobile-nav.tsx
│   └── theme-toggle.tsx
├── hooks/
│   ├── use-api.ts
│   ├── use-debounce.ts
│   ├── use-mobile.ts
│   └── use-toast.ts
└── lib/
    ├── db.ts
    ├── socket.ts
    └── utils.ts
```

---

## 🚀 Quick Start

### Development
```bash
npm install
npm run setup:db
npm run dev
```

### Production
```bash
npm run build
npm start
```

### Vercel Deployment
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

---

## ⚙️ Configuration

### Environment Variables
```env
DATABASE_URL="file:./db/custom.db"
NODE_ENV="production"
NEXT_PUBLIC_APP_URL="https://your-domain.com"
NEXT_PUBLIC_APP_NAME="VASCO D LUFFY Drug Safety Platform"
NEXTAUTH_SECRET="your-secret-here"
NEXTAUTH_URL="https://your-domain.com"
```

### Database Setup
```bash
npm run setup:db
npm run db:generate
npm run db:push
```

---

## 📸 Screenshots  
![Screenshot 1](https://github.com/user-attachments/assets/05e693f4-b9df-4215-8d76-691c836d78ba)  
![Screenshot 2](https://github.com/user-attachments/assets/418ada59-6302-40dd-aa3f-82959b855447)  
![Screenshot 3](https://github.com/user-attachments/assets/cfe743fb-bd2a-4d40-be73-cbe75c7b2832)  
![More Screens](https://github.com/user-attachments/assets/3b755588-25fc-4e22-9d24-87e8b4ebf944)  

---

## 🔒 Security & Privacy

- No personal data collected
- HTTPS communication
- Validated API endpoints
- Medical disclaimers and professional advice warnings

---

## 🤝 Contributions & Acknowledgements

- Contributions welcome from devs, doctors, and researchers
- Licensed under MIT
- Special thanks to healthcare experts, OSS contributors, and pharmaceutical data providers

---

## 🙏 Mission Statement

Making medication information accessible and actionable.

---

![Static Badge](https://img.shields.io/badge/Z.ai--Scaffold-Next.js%20%2B%20Tailwind%20%2B%20TypeScript-blue)

*VASCO D LUFFY - Making medication information accessible and actionable.*
