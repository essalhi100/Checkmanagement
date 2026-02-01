const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = 'https://eafsxriggorubqqsyezd.supabase.co';
const supabaseAnonKey = 'sb_publishable_ua-7c0iLf10GGsacyVZrDQ_y4zYM3Xc';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function verify() {
    try {
        console.log("Verifying schema update...");

        // Attempt to select 'user_id' from 'checks'.
        // If column exists, we get data or an empty array (if RLS blocks rows, we might get error, BUT the error will be different than 'column does not exist')
        // Actually, if RLS is on and we are anon, we might get 0 rows.
        // If the column does NOT exist, Supabase/Postgres throws usually "column does not exist" error irrespective of RLS (parsing stage).

        const { data, error } = await supabase.from('checks').select('user_id').limit(1);

        if (error) {
            if (error.message.includes('column') && error.message.includes('does not exist')) {
                console.log("RESULT: FAILED. The 'user_id' column is MISSING. The user has likely NOT run the SQL script.");
            } else {
                console.log("RESULT: LIKELY SUCCESS. Error encountered but it was NOT 'column missing'.");
                console.log("Error was:", error.message);
            }
        } else {
            console.log("RESULT: SUCCESS. The 'user_id' column exists.");
        }

    } catch (err) {
        console.error('Unexpected error:', err);
    }
}

verify();
