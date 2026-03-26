// functions/mesh-handshake.js
exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') return { statusCode: 405, body: 'Method Not Allowed' };

  try {
    const { deviceId, deviceType } = JSON.parse(event.body);
    // Simulate mesh handshake (Wi-Fi Direct/Multipeer)
    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        message: `Handshake successful with ${deviceType} (${deviceId})`,
        token: 'mesh_token_' + Math.random().toString(36).substring(2, 15),
      }),
    };
  } catch (error) {
    return { statusCode: 500, body: JSON.stringify({ error: error.message }) };
  }
};
