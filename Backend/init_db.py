import sqlite3

def init_db():
    conn = sqlite3.connect('resitrack.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            role TEXT NOT NULL
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS maintenance_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id INTEGER,
            description TEXT NOT NULL,
            status TEXT DEFAULT 'Pending',
            FOREIGN KEY(student_id) REFERENCES users(id)
        )
    ''')
    
    conn.commit()
    conn.close()
    print("Database 'resitrack.db' created successfully!")

if __name__ == '__main__':
    init_db()