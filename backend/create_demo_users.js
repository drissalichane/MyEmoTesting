const http = require('http');

// Configuration
const CONFIG = {
    hostname: 'localhost',
    port: 8082,
    headers: { 'Content-Type': 'application/json' }
};

// Helper function to make HTTP requests
const request = (path, method, body, token = null) => {
    return new Promise((resolve, reject) => {
        const data = body ? JSON.stringify(body) : '';
        const options = {
            ...CONFIG,
            path,
            method,
            headers: {
                ...CONFIG.headers,
                'Content-Length': data.length,
                ...(token ? { 'Authorization': `Bearer ${token}` } : {})
            }
        };

        const req = http.request(options, (res) => {
            let responseBody = '';
            res.on('data', (chunk) => { responseBody += chunk; });
            res.on('end', () => {
                const isSuccess = res.statusCode >= 200 && res.statusCode < 300;
                // Parse JSON if possible
                try {
                    const json = JSON.parse(responseBody);
                    resolve({ statusCode: res.statusCode, body: json, isSuccess });
                } catch (e) {
                    resolve({ statusCode: res.statusCode, body: responseBody, isSuccess });
                }
            });
        });

        req.on('error', (error) => {
            console.error(`❌ HTTP Error: ${error.message}`);
            reject(error);
        });

        if (data) req.write(data);
        req.end();
    });
};

// Main Logic
const main = async () => {
    console.log("🚀 Starting Demo Data Creation...");

    try {
        // 1. Register Doctor
        console.log("\n👨‍⚕️ Registering Doctor...");
        const doctorReg = await request('/api/auth/register', 'POST', {
            email: 'doctor1@example.com',
            password: 'password',
            firstName: 'John',
            lastName: 'Doe',
            role: 'DOCTOR'
        });

        let doctorId = doctorReg.body.userId; // Assuming backend returns userId on register

        if (doctorReg.isSuccess) {
            console.log(`✅ Doctor Registered (ID: ${doctorId})`);
        } else if (doctorReg.statusCode === 400 || doctorReg.statusCode === 409) {
            console.log(`ℹ️ Doctor already exists, attempting login...`);
        } else {
            console.error(`❌ Failed to register Doctor: ${JSON.stringify(doctorReg.body)}`);
            return;
        }

        // 2. Login as Doctor (to get Token and confirm ID)
        console.log("🔐 Logging in as Doctor...");
        const doctorLogin = await request('/api/auth/login', 'POST', {
            email: 'doctor1@example.com',
            password: 'password'
        });

        if (!doctorLogin.isSuccess) {
            console.error(`❌ Doctor Login Failed: ${JSON.stringify(doctorLogin.body)}`);
            return;
        }

        const doctorToken = doctorLogin.body.accessToken;
        doctorId = doctorLogin.body.userId;
        console.log(`✅ Doctor Logged In (Token received)`);

        // 3. Register Patient
        console.log("\n🤒 Registering Patient...");
        const patientReg = await request('/api/auth/register', 'POST', {
            email: 'patient1@example.com',
            password: 'password',
            firstName: 'Alice',
            lastName: 'Dupont',
            role: 'PATIENT'
        });

        let patientId = patientReg.body.userId;

        if (patientReg.isSuccess) {
            console.log(`✅ Patient Registered (ID: ${patientId})`);
        } else if (patientReg.statusCode === 400 || patientReg.statusCode === 409) {
            console.log(`ℹ️ Patient might already exist, attempting login to get ID...`);
            // Login patient to get ID
            const patientLogin = await request('/api/auth/login', 'POST', {
                email: 'patient1@example.com',
                password: 'password'
            });
            if (patientLogin.isSuccess) {
                patientId = patientLogin.body.userId;
                console.log(`✅ Retrieved existing Patient ID: ${patientId}`);
            } else {
                console.error("❌ Could not retrieve patient ID.");
                return;
            }
        } else {
            console.error(`❌ Failed to register Patient: ${JSON.stringify(patientReg.body)}`);
            return;
        }

        // 4. Assign Patient to Doctor
        if (doctorId && patientId) {
            console.log(`\n🔗 Assigning Patient (${patientId}) to Doctor (${doctorId})...`);
            const assignment = await request(`/api/doctors/assign/${patientId}`, 'POST', {}, doctorToken);

            if (assignment.isSuccess) {
                console.log(`✅ SUCCESS: Patient assigned to Doctor!`);
            } else {
                console.error(`❌ Assignment Failed: ${JSON.stringify(assignment.body)}`);
            }
        }

        // 5. Register E2E Test User (Optional)
        console.log("\n🤖 Registering E2E Doctor...");
        await request('/api/auth/register', 'POST', {
            email: 'e2e_doctor@example.com',
            password: 'password123',
            firstName: 'E2E',
            lastName: 'Tester',
            role: 'DOCTOR'
        });
        console.log("✅ E2E Doctor processed");

        // 6. Register E2E Doctor V2 (Fresh credentials)
        console.log("\n🤖 Registering E2E Doctor V2...");
        await request('/api/auth/register', 'POST', {
            email: 'e2e_doctor_v2@example.com',
            password: 'password123',
            firstName: 'E2E',
            lastName: 'TesterV2',
            role: 'DOCTOR'
        });
        console.log("✅ E2E Doctor V2 processed");

    } catch (e) {
        console.error("❌ Unexpected Error:", e);
    }
};

main();
