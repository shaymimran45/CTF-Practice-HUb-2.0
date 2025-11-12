# Supabase Issues Fix Guide

This guide addresses common Supabase issues including foreign key constraint errors and Row Level Security (RLS) policy violations.

## Common Issues and Solutions

### 1. Foreign Key Constraint Errors

**Error Message**: `insert or update on table "users" violates foreign key constraint "users_id_fkey"`

**Cause**: This happens when trying to insert a record into the `public.users` table without a corresponding record in the `auth.users` table.

**Solution**: 
1. Run the `SUPABASE_FK_FIX.sql` script to properly configure foreign key constraints
2. Use triggers to automatically create user profiles when auth users are created

### 2. Row Level Security Policy Violations

**Error Message**: `new row violates row-level security policy for table "users"`

**Cause**: This happens when RLS policies are too restrictive or incorrectly configured.

**Solution**:
1. Run the `SUPABASE_RLS_FIX.sql` script to properly configure RLS policies
2. Ensure policies allow authenticated users to insert their own data

## Step-by-Step Fix Process

### Step 1: Apply Foreign Key Constraint Fix

1. Go to your Supabase project dashboard
2. Navigate to the SQL editor
3. Copy and paste the contents of `SUPABASE_FK_FIX.sql`
4. Run the script

### Step 2: Apply RLS Policy Fix

1. In the same SQL editor, copy and paste the contents of `SUPABASE_RLS_FIX.sql`
2. Run the script

### Step 3: Verify the Fixes

1. Try to register a new user through the application
2. Check that the user record is automatically created in the `public.users` table
3. Test admin functionality by setting the `role` field in user metadata

## Manual User Creation (If Needed)

If automatic user creation isn't working, you can manually create users:

```sql
-- Insert a new user record (replace with actual values)
INSERT INTO public.users (id, username, email, created_at)
VALUES (
  'USER_UUID_HERE',  -- Replace with actual UUID
  'username_here',   -- Replace with actual username
  'email@example.com', -- Replace with actual email
  NOW()
);
```

## Setting Up Admin Users

To create an admin user:

1. Register a user through the normal registration process
2. In your Supabase dashboard, go to the Authentication > Users section
3. Find your user and click on the "User metadata" tab
4. Add the following JSON to the user metadata:

```json
{
  "role": "admin"
}
```

Alternatively, you can update user metadata directly with SQL:

```sql
-- Update user metadata to set admin role
UPDATE auth.users 
SET raw_user_meta_data = jsonb_set(
  COALESCE(raw_user_meta_data, '{}'), 
  '{role}', 
  '"admin"'
)
WHERE email = 'admin@example.com';  -- Replace with actual admin email
```

## Testing the Fixes

1. Restart your development server: `npm run dev`
2. Visit http://localhost:3000/register and create a new user
3. Verify that the user is automatically added to the `public.users` table
4. Log in with the new user and verify normal functionality
5. Set up an admin user and test admin functionality at http://localhost:3000/admin

## Troubleshooting

### If Issues Persist:

1. **Check Table Structure**:
   ```sql
   -- Verify table structure
   \d users
   \d problems
   ```

2. **Check Constraints**:
   ```sql
   -- Check foreign key constraints
   SELECT 
     conname AS constraint_name,
     conrelid::regclass AS table_name,
     confrelid::regclass AS referenced_table
   FROM pg_constraint 
   WHERE contype = 'f' AND connamespace = 'public'::regnamespace;
   ```

3. **Check RLS Policies**:
   ```sql
   -- Check RLS policies
   SELECT 
     polname AS policy_name,
     polrelid::regclass AS table_name,
     polcmd AS command,
     polqual AS qualification
   FROM pg_policy 
   WHERE polrelid IN (
     SELECT oid FROM pg_class 
     WHERE relnamespace = 'public'::regnamespace
   );
   ```

4. **Check User Metadata**:
   ```sql
   -- Check user metadata
   SELECT id, email, raw_user_meta_data 
   FROM auth.users 
   LIMIT 5;
   ```

## Prevention for Future Issues

1. Always use the provided setup scripts
2. Test user registration after any schema changes
3. Verify RLS policies match your application requirements
4. Keep backup copies of working configurations