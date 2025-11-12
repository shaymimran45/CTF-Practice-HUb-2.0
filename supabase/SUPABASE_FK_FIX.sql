-- Supabase Foreign Key Constraint Fix
-- This script addresses issues with foreign key constraints between public.users and auth.users

-- First, let's drop the existing foreign key constraint
ALTER TABLE users DROP CONSTRAINT IF EXISTS users_id_fkey;

-- Then recreate it with proper deferrable settings
ALTER TABLE users 
ADD CONSTRAINT users_id_fkey 
FOREIGN KEY (id) 
REFERENCES auth.users(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE 
DEFERRABLE INITIALLY DEFERRED;

-- Also fix the foreign key constraints in related tables
ALTER TABLE submissions DROP CONSTRAINT IF EXISTS submissions_user_id_fkey;
ALTER TABLE submissions 
ADD CONSTRAINT submissions_user_id_fkey 
FOREIGN KEY (user_id) 
REFERENCES users(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE 
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE user_progress DROP CONSTRAINT IF EXISTS user_progress_user_id_fkey;
ALTER TABLE user_progress 
ADD CONSTRAINT user_progress_user_id_fkey 
FOREIGN KEY (user_id) 
REFERENCES users(id) 
ON DELETE CASCADE 
ON UPDATE CASCADE 
DEFERRABLE INITIALLY DEFERRED;

-- Create a trigger function to automatically create user profiles
-- This will help avoid foreign key constraint violations
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, username, email, created_at)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', SPLIT_PART(NEW.email, '@', 1)),
    NEW.email,
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create the trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated;
GRANT ALL ON TABLE public.users TO postgres, anon, authenticated;
GRANT ALL ON TABLE public.problems TO postgres, anon, authenticated;
GRANT ALL ON TABLE public.categories TO postgres, anon, authenticated;
GRANT ALL ON TABLE public.submissions TO postgres, anon, authenticated;
GRANT ALL ON TABLE public.user_progress TO postgres, anon, authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated;