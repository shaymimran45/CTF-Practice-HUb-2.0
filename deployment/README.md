# CTF Practice Website Deployment

This folder contains all the necessary files for deploying the CTF Practice website to Render and hosting on GitHub.

## Folder Structure

- `app/` - Contains all application source code and configuration files
- `supabase/` - Contains Supabase database schema and setup files
- `docs/` - Contains documentation files

## Deployment to Render

### Prerequisites
1. A Render account
2. A Supabase account
3. Environment variables set up in Render

### Steps

1. **Set up Supabase Database**
   - Create a new Supabase project
   - Go to the SQL editor
   - Run the `supabase/SUPABASE_SCHEMA_UPDATED.sql` script
   - Apply the fixes in `supabase/SUPABASE_FK_FIX.sql` and `supabase/SUPABASE_RLS_FIX.sql` if needed

2. **Configure Environment Variables in Render**
   - `NEXT_PUBLIC_SUPABASE_URL` - Your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Your Supabase anon key
   - `SUPABASE_SERVICE_KEY` - Your Supabase service key
   - `PORT` - Set to 10000

3. **Deploy to Render**
   - Connect your GitHub repository to Render
   - Select the `app/` directory as the root
   - Set the build command to `npm run build`
   - Set the start command to `npm start`

## GitHub Repository Structure

When pushing to GitHub, the repository should contain:
- All files from the `app/` directory at the root level
- Supabase setup files in a `supabase/` directory
- Documentation files in a `docs/` directory

## Environment Configuration

The application requires the following environment variables:
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `SUPABASE_SERVICE_KEY` - Supabase service key (for server-side operations)

## Supabase Setup

1. Run `supabase/SUPABASE_SCHEMA_UPDATED.sql` to create tables and insert sample data
2. Apply `supabase/SUPABASE_FK_FIX.sql` if you encounter foreign key constraint errors
3. Apply `supabase/SUPABASE_RLS_FIX.sql` if you encounter RLS policy violations
4. Set up admin users by adding `{"role": "admin"}` to user metadata in Supabase dashboard

## Testing

After deployment:
1. Visit the deployed URL
2. Register a new user
3. Verify that challenges are displayed
4. Test admin functionality by setting up an admin user