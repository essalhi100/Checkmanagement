const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://hbycnloggmuovsxulzuv.supabase.co';
const supabaseAnonKey = 'sb_publishable_P6sc647KZDinDYnsoZ1MtA_RdGMRSc3';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function test() {
    try {
        console.log("Checking if 'user_id' column exists...");

        // Attempt to select 'user_id'. If it doesn't exist, this will throw/return error.
        const { data, error } = await supabase.from('checks').select('user_id').limit(1);

        if (error) {
            console.log("Error selecting user_id:", error.message);
            console.log("It likely does NOT exist or RLS is blocking it completely.");
        } else {
            console.log("'user_id' column exists and is accessible.");
        }

    } catch (err) {
        console.error('Unexpected error:', err);
    }
}

test();
