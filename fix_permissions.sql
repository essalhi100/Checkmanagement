-- 1. Ensure user_id column exists (Safe add)
-- This allows the script to be run even if the column is missing
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'checks' AND column_name = 'user_id') THEN 
        ALTER TABLE checks ADD COLUMN user_id UUID REFERENCES auth.users; 
    END IF; 
END $$;

DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'system_settings' AND column_name = 'user_id') THEN 
        ALTER TABLE system_settings ADD COLUMN user_id UUID REFERENCES auth.users; 
    END IF; 
END $$;

-- 2. Enable RLS
ALTER TABLE checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_settings ENABLE ROW LEVEL SECURITY;

-- 3. Safely drop old policies to avoid "already exists" errors
DROP POLICY IF EXISTS "Users can insert their own checks" ON checks;
DROP POLICY IF EXISTS "Users can view their own checks" ON checks;
DROP POLICY IF EXISTS "Users can update their own checks" ON checks;
DROP POLICY IF EXISTS "Users can delete their own checks" ON checks;

DROP POLICY IF EXISTS "Users can view their own settings" ON system_settings;
DROP POLICY IF EXISTS "Users can insert their own settings" ON system_settings;
DROP POLICY IF EXISTS "Users can update their own settings" ON system_settings;
DROP POLICY IF EXISTS "Users can update their own settings update" ON system_settings; 

-- 4. Re-create Policies

-- CHECKS Table Policies
CREATE POLICY "Users can insert their own checks" 
ON checks FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own checks" 
ON checks FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own checks" 
ON checks FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own checks" 
ON checks FOR DELETE 
TO authenticated 
USING (auth.uid() = user_id);

-- SYSTEM_SETTINGS Table Policies
CREATE POLICY "Users can view their own settings" 
ON system_settings FOR SELECT 
TO authenticated 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own settings" 
ON system_settings FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings" 
ON system_settings FOR UPDATE 
TO authenticated 
USING (auth.uid() = user_id);
