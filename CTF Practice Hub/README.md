# CTF Practice Hub

A dynamic CTF (Capture The Flag) practice website built with Next.js and Supabase.

## Features

- Multiple challenge categories (Web, Crypto, Reversing, Forensics, Pwn, Misc)
- Dynamic challenge loading from Supabase
- User progress tracking
- Leaderboard system
- Responsive design for all devices
- Admin dashboard for challenge management

## Prerequisites

- Node.js 18 or higher
- A Supabase account

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env` file based on `.env.example` and fill in your Supabase credentials

4. Set up the Supabase database:
   - Run the SQL script from `supabase/SUPABASE_SCHEMA_UPDATED.sql` in your Supabase SQL editor
   - Apply the fixes in `supabase/SUPABASE_FK_FIX.sql` and `supabase/SUPABASE_RLS_FIX.sql` if needed

5. Run the development server:
   ```bash
   npm run dev
   ```

6. Open [http://localhost:3000](http://localhost:3000) in your browser

## Deployment

This project is configured for deployment to Render. Make sure to set the following environment variables in your Render dashboard:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_KEY`
- `PORT` (set to 10000)

## Supabase Setup

1. Create a new Supabase project
2. Run the database initialization script
3. Set up admin users by adding `{"role": "admin"}` to user metadata

## Learn More

To learn more about the technologies used in this project:

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.io/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)