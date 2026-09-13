from flask import Flask, jsonify, request
from flask_cors import CORS
import sqlite3

app = Flask(__name__)
CORS(app)  # Enables cross-origin requests for Flutter web/mobile

def get_db_connection():
    conn = sqlite3.connect('resitrack.db')
    conn.row_factory = sqlite3.Row
    return conn

# Status endpoint to test connection
@app.route('/api/status', methods=['GET'])
def get_status():
    return jsonify({"status": "active", "message": "UFH-Resitrack API is running!"})

# Fetch all maintenance requests
@app.route('/api/requests', methods=['GET'])
def get_requests():
    conn = get_db_connection()
    requests = conn.execute('SELECT * FROM maintenance_requests').fetchall()
    conn.close()
    return jsonify([dict(req) for req in requests])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)