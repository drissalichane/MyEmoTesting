const http = require('http');

const registerUser = (user) => {
    const data = JSON.stringify(user);
    const options = {
        hostname: 'localhost',
        port: 8082,
        path: '/api/auth/register',
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': data.length
        }
    };

    const req = http.request(options, (res) => {
        let responseBody = '';
        res.on('data', (chunk) => { responseBody += chunk; });
        res.on('end', () => {
            if (res.statusCode === 200 || res.statusCode === 201) {
                console.log(`✅ Success: Registered ${user.email}`);
            } else if (res.statusCode === 400 || res.statusCode === 409) {
                // Assume 400/409 means already exists, which is fine
                console.log(`ℹ️ Info: ${user.email} might already exist (Status: ${res.statusCode})`);
            } else {
                console.error(`❌ Failed: ${user.email} (Status: ${res.statusCode})`);
                console.error(responseBody);
            }
        });
    });

    req.on('error', (error) => {
        console.error(`❌ Error connecting to backend: ${error.message}`);
    });

    req.write(data);
    req.end();
};

// Demo Doctor
registerUser({
    email: 'doctor1@example.com',
    password: 'password',
    firstName: 'John',
    lastName: 'Doe',
    role: 'DOCTOR'
});

// Demo Patient
setTimeout(() => {
    registerUser({
        email: 'patient1@example.com',
        password: 'password',
        firstName: 'Alice',
        lastName: 'Dupont',
        role: 'PATIENT'
    });
}, 1000);
