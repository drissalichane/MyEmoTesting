const BASE_URL = 'http://localhost:8082';
let patientToken = '';
let doctorToken = '';
let patientId = '';
let doctorId = '';

// Helper function to make requests
async function makeRequest(method, endpoint, body = null, token = null) {
    const headers = {
        'Content-Type': 'application/json'
    };

    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    const options = {
        method,
        headers
    };

    if (body) {
        options.body = JSON.stringify(body);
    }

    try {
        const response = await fetch(`${BASE_URL}${endpoint}`, options);
        const data = await response.json().catch(() => null);
        return {
            status: response.status,
            ok: response.ok,
            data
        };
    } catch (error) {
        return {
            status: 0,
            ok: false,
            error: error.message
        };
    }
}

// Test Results
const results = {
    passed: 0,
    failed: 0,
    tests: []
};

function logTest(name, passed, details) {
    console.log(`${passed ? '✅' : '❌'} ${name}`);
    if (details) console.log(`   ${details}`);
    results.tests.push({ name, passed, details });
    if (passed) results.passed++;
    else results.failed++;
}

// Run Tests
async function runTests() {
    console.log('🚀 Starting Backend API Tests...\n');

    // Test 1: Register Patient
    console.log('📝 Authentication Tests');
    const registerPatient = await makeRequest('POST', '/api/auth/register', {
        email: `patient${Date.now()}@test.com`,
        password: 'Test123!',
        firstName: 'John',
        lastName: 'Doe',
        role: 'PATIENT'
    });
    logTest('Register Patient', registerPatient.ok, `Status: ${registerPatient.status}`);
    if (registerPatient.ok) {
        patientId = registerPatient.data.userId;
        patientToken = registerPatient.data.accessToken;
        console.log(`   Patient ID: ${patientId}, Token: ${patientToken ? 'Received' : 'Missing'}`);
    }

    // Test 2: Register Doctor
    const registerDoctor = await makeRequest('POST', '/api/auth/register', {
        email: `doctor${Date.now()}@test.com`,
        password: 'Test123!',
        firstName: 'Jane',
        lastName: 'Smith',
        role: 'DOCTOR'
    });
    logTest('Register Doctor', registerDoctor.ok, `Status: ${registerDoctor.status}`);
    if (registerDoctor.ok) {
        doctorId = registerDoctor.data.userId;
        doctorToken = registerDoctor.data.accessToken;
        console.log(`   Doctor ID: ${doctorId}, Token: ${doctorToken ? 'Received' : 'Missing'}`);
    }

    // Test 3: Login Patient (if we have patient email)
    if (registerPatient.data?.email) {
        const loginPatient = await makeRequest('POST', '/api/auth/login', {
            email: registerPatient.data.email,
            password: 'Test123!'
        });
        logTest('Login Patient', loginPatient.ok && loginPatient.data?.accessToken,
            `Status: ${loginPatient.status}, Token: ${loginPatient.data?.accessToken ? 'Received' : 'Missing'}`);
        if (loginPatient.ok && loginPatient.data?.accessToken) {
            patientToken = loginPatient.data.accessToken;
        }
    }

    // Test 4: Login Doctor
    if (registerDoctor.data?.email) {
        const loginDoctor = await makeRequest('POST', '/api/auth/login', {
            email: registerDoctor.data.email,
            password: 'Test123!'
        });
        logTest('Login Doctor', loginDoctor.ok && loginDoctor.data?.accessToken,
            `Status: ${loginDoctor.status}, Token: ${loginDoctor.data?.accessToken ? 'Received' : 'Missing'}`);
        if (loginDoctor.ok && loginDoctor.data?.accessToken) {
            doctorToken = loginDoctor.data.accessToken;
        }
    }

    // Test 5: Invalid Login
    const invalidLogin = await makeRequest('POST', '/api/auth/login', {
        email: 'nonexistent@test.com',
        password: 'WrongPassword'
    });
    logTest('Invalid Login (should fail)', !invalidLogin.ok, `Status: ${invalidLogin.status}`);

    // Test 6: Access Without Token
    const noToken = await makeRequest('GET', '/api/users/me');
    logTest('Access Protected Endpoint Without Token (should fail)', !noToken.ok, `Status: ${noToken.status}`);

    console.log('\n👤 User Management Tests');

    // Test 7: Get Current User
    if (patientToken) {
        const getCurrentUser = await makeRequest('GET', '/api/users/me', null, patientToken);
        logTest('Get Current User', getCurrentUser.ok && getCurrentUser.data?.email,
            `Status: ${getCurrentUser.status}, Email: ${getCurrentUser.data?.email}`);
    } else {
        logTest('Get Current User', false, 'No patient token available');
    }

    // Test 8: Get All Users
    if (patientToken) {
        const getAllUsers = await makeRequest('GET', '/api/users', null, patientToken);
        logTest('Get All Users', getAllUsers.ok && Array.isArray(getAllUsers.data),
            `Status: ${getAllUsers.status}, Count: ${getAllUsers.data?.length || 0}`);
    }

    // Test 9: Get All Patients
    if (doctorToken) {
        const getPatients = await makeRequest('GET', '/api/users/patients', null, doctorToken);
        logTest('Get All Patients', getPatients.ok && Array.isArray(getPatients.data),
            `Status: ${getPatients.status}, Count: ${getPatients.data?.length || 0}`);
    }

    // Test 10: Get All Doctors
    if (patientToken) {
        const getDoctors = await makeRequest('GET', '/api/users/doctors', null, patientToken);
        logTest('Get All Doctors', getDoctors.ok && Array.isArray(getDoctors.data),
            `Status: ${getDoctors.status}, Count: ${getDoctors.data?.length || 0}`);
    }

    // Test 11: Get User by ID
    if (patientId && patientToken) {
        const getUserById = await makeRequest('GET', `/api/users/${patientId}`, null, patientToken);
        logTest('Get User by ID', getUserById.ok,
            `Status: ${getUserById.status}, User: ${getUserById.data?.email}`);
    }

    // Test 12: Update User
    if (patientId && patientToken) {
        const updateUser = await makeRequest('PUT', `/api/users/${patientId}`, {
            firstName: 'John Updated',
            lastName: 'Doe Updated'
        }, patientToken);
        logTest('Update User', updateUser.ok && updateUser.data?.firstName === 'John Updated',
            `Status: ${updateUser.status}, Name: ${updateUser.data?.firstName} ${updateUser.data?.lastName}`);
    }

    // Summary
    console.log('\n' + '='.repeat(50));
    console.log(`📊 Test Summary: ${results.passed} passed, ${results.failed} failed`);
    console.log('='.repeat(50));

    if (results.failed > 0) {
        console.log('\n❌ Failed Tests:');
        results.tests.filter(t => !t.passed).forEach(t => {
            console.log(`   - ${t.name}: ${t.details}`);
        });
    } else {
        console.log('\n🎉 All tests passed!');
    }
}

// Run the tests
runTests().catch(console.error);
