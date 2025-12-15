const BASE_URL = 'http://localhost:8082';

// Test state
let patientToken = '';
let patientId = '';
const results = { passed: 0, failed: 0, tests: [] };

// Helper function
async function makeRequest(method, endpoint, body = null, token = null) {
    const headers = { 'Content-Type': 'application/json' };
    if (token) headers['Authorization'] = `Bearer ${token}`;

    const options = { method, headers };
    if (body) options.body = JSON.stringify(body);

    try {
        const response = await fetch(`${BASE_URL}${endpoint}`, options);
        let data = null;
        try {
            data = await response.json();
        } catch (e) {
            // Response might not have JSON body
        }
        return { status: response.status, ok: response.ok, data };
    } catch (error) {
        return { status: 0, ok: false, error: error.message };
    }
}

function logTest(name, passed, details) {
    console.log(`${passed ? '✅' : '❌'} ${name}`);
    if (details) console.log(`   ${details}`);
    results.tests.push({ name, passed, details });
    if (passed) results.passed++;
    else results.failed++;
}

// Main test function
async function runQcmTests() {
    console.log('🚀 Starting QCM/Test Endpoints Testing...\n');

    // Setup: Register and login a patient
    console.log('📝 Setup: Creating test patient');
    const registerResp = await makeRequest('POST', '/api/auth/register', {
        email: `qcm.patient${Date.now()}@test.com`,
        password: 'Test123!',
        firstName: 'QCM',
        lastName: 'Tester',
        role: 'PATIENT'
    });

    if (!registerResp.ok) {
        console.log('❌ Failed to register patient. Aborting tests.');
        return;
    }

    patientToken = registerResp.data.accessToken;
    patientId = registerResp.data.userId;
    console.log(`✅ Patient created (ID: ${patientId})\n`);

    // TEST 1: Start a test
    console.log('🧪 Test Endpoints');
    const startResp = await makeRequest('POST', '/api/tests/start', {
        patientId: patientId,
        qcmId: 1, // First QCM template (Initial Mood Assessment)
        phaseId: 1
    }, patientToken);

    logTest('Start Test', startResp.status === 201,
        `Status: ${startResp.status}`);

    // Get the created test from patient tests list
    let testId = null;
    const patientTestsResp = await makeRequest('GET', `/api/tests/patient/${patientId}`, null, patientToken);

    if (patientTestsResp.ok && patientTestsResp.data && patientTestsResp.data.length > 0) {
        testId = patientTestsResp.data[patientTestsResp.data.length - 1].id; // Get latest test
        console.log(`   Retrieved test ID: ${testId}`);
    }

    // TEST 2: Get patient tests
    logTest('Get Patient Tests', patientTestsResp.ok && Array.isArray(patientTestsResp.data) && patientTestsResp.data.length > 0,
        `Status: ${patientTestsResp.status}, Count: ${patientTestsResp.data?.length || 0}`);

    // TEST 3: Get test by ID
    if (testId) {
        const getTestResp = await makeRequest('GET', `/api/tests/${testId}`, null, patientToken);
        logTest('Get Test by ID', getTestResp.ok,
            `Status: ${getTestResp.status}`);
    }

    // TEST 4: Submit perfect answers (should PASS with score >= 7.5)
    if (testId) {
        console.log('\n📝 Testing Answer Submission & Scoring');

        // Create perfect answers for Initial Mood Assessment QCM
        const perfectAnswers = [
            {
                question: { id: 1 },
                valueNumeric: 10, // SCALE: 10/10
                selectedOptions: null,
                valueText: null
            },
            {
                question: { id: 2 },
                valueNumeric: null,
                selectedOptions: { value: 'D' }, // SINGLE_CHOICE: "Rarely" = 10 points
                valueText: null
            },
            {
                question: { id: 3 },
                valueNumeric: null,
                selectedOptions: { values: ['E'] }, // MULTIPLE_CHOICE: "None of the above" = 10 points
                valueText: null
            },
            {
                question: { id: 4 },
                valueNumeric: null,
                selectedOptions: { value: 'D' }, // SINGLE_CHOICE: "Good sleep" = 10 points
                valueText: null
            },
            {
                question: { id: 5 },
                valueNumeric: 10, // SCALE: 10/10
                selectedOptions: null,
                valueText: null
            },
            {
                question: { id: 6 },
                valueNumeric: null,
                selectedOptions: null,
                valueText: 'I am doing well and have no major concerns.' // TEXT: 0 points
            }
        ];

        const submitResp = await makeRequest('POST', `/api/tests/${testId}/submit`, {
            answers: perfectAnswers
        }, patientToken);

        logTest('Submit Perfect Answers', submitResp.ok,
            `Status: ${submitResp.status}`);

        // TEST 5: Get test result
        if (submitResp.ok) {
            const resultResp = await makeRequest('GET', `/api/tests/${testId}/result`, null, patientToken);
            const passed = resultResp.ok && resultResp.data?.score >= 7.5 && resultResp.data?.status === 'PASSED';
            logTest('Verify PASSED Status (score >= 7.5)', passed,
                `Status: ${resultResp.status}, Score: ${resultResp.data?.score || 'N/A'}/10, Result: ${resultResp.data?.status || 'N/A'}`);
        }
    }

    // TEST 6: Start another test with poor answers (should FAIL)
    const startTest2Resp = await makeRequest('POST', '/api/tests/start', {
        patientId: patientId,
        qcmId: 1,
        phaseId: 1
    }, patientToken);

    if (startTest2Resp.status === 201) {
        // Get the new test ID
        const patientTests2Resp = await makeRequest('GET', `/api/tests/patient/${patientId}`, null, patientToken);
        let testId2 = null;

        if (patientTests2Resp.ok && patientTests2Resp.data && patientTests2Resp.data.length > 1) {
            testId2 = patientTests2Resp.data[patientTests2Resp.data.length - 1].id;

            // Create poor answers (should fail with score < 7.5)
            const poorAnswers = [
                {
                    question: { id: 1 },
                    valueNumeric: 1, // SCALE: 1/10
                    selectedOptions: null,
                    valueText: null
                },
                {
                    question: { id: 2 },
                    valueNumeric: null,
                    selectedOptions: { value: 'A' }, // "Very often" = 2 points
                    valueText: null
                },
                {
                    question: { id: 3 },
                    valueNumeric: null,
                    selectedOptions: { values: ['A', 'B', 'C', 'D'] }, // All symptoms = 8 points
                    valueText: null
                },
                {
                    question: { id: 4 },
                    valueNumeric: null,
                    selectedOptions: { value: 'A' }, // "Very poor sleep" = 0 points
                    valueText: null
                },
                {
                    question: { id: 5 },
                    valueNumeric: 2, // SCALE: 2/10
                    selectedOptions: null,
                    valueText: null
                },
                {
                    question: { id: 6 },
                    valueNumeric: null,
                    selectedOptions: null,
                    valueText: 'Struggling.' // TEXT: 0 points
                }
            ];

            const submitPoorResp = await makeRequest('POST', `/api/tests/${testId2}/submit`, {
                answers: poorAnswers
            }, patientToken);

            if (submitPoorResp.ok) {
                const resultResp2 = await makeRequest('GET', `/api/tests/${testId2}/result`, null, patientToken);
                const failed = resultResp2.ok && resultResp2.data?.score < 7.5 && resultResp2.data?.status === 'FAILED';
                logTest('Verify FAILED Status (score < 7.5)', failed,
                    `Status: ${resultResp2.status}, Score: ${resultResp2.data?.score || 'N/A'}/10, Result: ${resultResp2.data?.status || 'N/A'}`);
            }
        }
    }

    // TEST 7: Try to resubmit to completed test (should fail)
    if (testId) {
        const resubmitResp = await makeRequest('POST', `/api/tests/${testId}/submit`, {
            answers: []
        }, patientToken);

        logTest('Resubmit to Completed Test (should fail)', !resubmitResp.ok || resubmitResp.status >= 400,
            `Status: ${resubmitResp.status}`);
    }

    // TEST 8: Try to start test with invalid QCM ID
    const invalidQcmResp = await makeRequest('POST', '/api/tests/start', {
        patientId: patientId,
        qcmId: 99999,
        phaseId: 1
    }, patientToken);

    logTest('Start Test with Invalid QCM ID (should fail)', invalidQcmResp.status >= 400,
        `Status: ${invalidQcmResp.status}`);

    // TEST 9: Try to get non-existent test
    const nonExistentResp = await makeRequest('GET', '/api/tests/99999', null, patientToken);
    logTest('Get Non-Existent Test (should fail)', nonExistentResp.status >= 400,
        `Status: ${nonExistentResp.status}`);

    // TEST 10: Get patient tests by phase
    const phaseTestsResp = await makeRequest('GET', `/api/tests/patient/${patientId}/phase/1`, null, patientToken);
    logTest('Get Patient Tests by Phase', phaseTestsResp.ok && Array.isArray(phaseTestsResp.data),
        `Status: ${phaseTestsResp.status}, Count: ${phaseTestsResp.data?.length || 0}`);

    // Summary
    console.log('\n' + '='.repeat(50));
    console.log(`📊 QCM Test Summary: ${results.passed} passed, ${results.failed} failed`);
    console.log('='.repeat(50));

    if (results.failed > 0) {
        console.log('\n❌ Failed Tests:');
        results.tests.filter(t => !t.passed).forEach(t => {
            console.log(`   - ${t.name}: ${t.details}`);
        });
    } else {
        console.log('\n🎉 All QCM tests passed!');
    }

    console.log('\n📈 Test Data Summary:');
    console.log(`   - Total Tests Run: ${results.tests.length}`);
    console.log(`   - Pass Rate: ${((results.passed / results.tests.length) * 100).toFixed(1)}%`);
}

// Run the tests
runQcmTests().catch(console.error);
