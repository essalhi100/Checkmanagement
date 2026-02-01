-- Update CHECKS table
UPDATE checks 
SET user_id = 'a01d1ead-acfd-4c26-adbd-cc5fbf9b5302' 
WHERE user_id IS NULL;

-- Update SYSTEM_SETTINGS table
UPDATE system_settings 
SET user_id = 'a01d1ead-acfd-4c26-adbd-cc5fbf9b5302' 
WHERE user_id IS NULL;

-- Just in case RLS was preventing the update, we temporarily disable it to run this fix
-- (Only if you are running this as a SUPERUSER / Dashboard Editor)
-- ALTER TABLE checks DISABLE ROW LEVEL SECURITY;
-- UPDATE ...
-- ALTER TABLE checks ENABLE ROW LEVEL SECURITY;
