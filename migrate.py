import mysql.connector
import sqlite3
from decimal import Decimal

# MySQL connection
mysql_conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Daniel2002",  # Your MySQL password here
    database="bike_store"
)

# SQLite connection
sqlite_conn = sqlite3.connect('bike_store.db')

mysql_cursor = mysql_conn.cursor()
sqlite_cursor = sqlite_conn.cursor()

# Get all tables
mysql_cursor.execute("SHOW TABLES")
tables = mysql_cursor.fetchall()

for (table_name,) in tables:
    print(f"Migrating table: {table_name}")
    
    # Drop table if exists to recreate properly
    sqlite_cursor.execute(f"DROP TABLE IF EXISTS {table_name}")
    
    # Get column information
    mysql_cursor.execute(f"DESCRIBE {table_name}")
    columns = mysql_cursor.fetchall()
    
    # Get primary key information
    mysql_cursor.execute(f"SHOW KEYS FROM {table_name} WHERE Key_name = 'PRIMARY'")
    primary_keys = [row[4] for row in mysql_cursor.fetchall()]
    
    # Build SQLite CREATE TABLE statement
    col_definitions = []
    for col in columns:
        col_name = col[0]
        col_type = col[1].decode() if isinstance(col[1], bytes) else col[1]
        
        # Convert MySQL types to SQLite types
        if 'int' in col_type.lower():
            sqlite_type = 'INTEGER'
        elif 'varchar' in col_type.lower() or 'text' in col_type.lower() or 'char' in col_type.lower():
            sqlite_type = 'TEXT'
        elif 'decimal' in col_type.lower() or 'float' in col_type.lower() or 'double' in col_type.lower():
            sqlite_type = 'REAL'
        elif 'date' in col_type.lower() or 'time' in col_type.lower():
            sqlite_type = 'TEXT'
        else:
            sqlite_type = 'TEXT'
        
        # Don't add PRIMARY KEY to individual columns if composite key
        col_definitions.append(f"{col_name} {sqlite_type}")
    
    # Add PRIMARY KEY constraint at the end if there are primary keys
    if primary_keys:
        if len(primary_keys) == 1:
            # Single primary key - add it to the column definition
            create_statement = f"CREATE TABLE IF NOT EXISTS {table_name} ({', '.join(col_definitions)})"
            # Find and update the primary key column
            pk_col = primary_keys[0]
            col_definitions_updated = []
            for col_def in col_definitions:
                if col_def.startswith(pk_col + ' '):
                    col_definitions_updated.append(col_def + ' PRIMARY KEY')
                else:
                    col_definitions_updated.append(col_def)
            create_statement = f"CREATE TABLE IF NOT EXISTS {table_name} ({', '.join(col_definitions_updated)})"
        else:
            # Composite primary key
            pk_constraint = f"PRIMARY KEY ({', '.join(primary_keys)})"
            create_statement = f"CREATE TABLE IF NOT EXISTS {table_name} ({', '.join(col_definitions)}, {pk_constraint})"
    else:
        create_statement = f"CREATE TABLE IF NOT EXISTS {table_name} ({', '.join(col_definitions)})"
    
    # Create table in SQLite
    try:
        sqlite_cursor.execute(create_statement)
        print(f"  ✓ Table created: {table_name}")
    except Exception as e:
        print(f"  ✗ Error creating table {table_name}: {e}")
        continue
    
    # Copy data
    mysql_cursor.execute(f"SELECT * FROM {table_name}")
    rows = mysql_cursor.fetchall()
    
    if rows:
        # Convert Decimal objects to float for SQLite
        converted_rows = []
        for row in rows:
            converted_row = []
            for value in row:
                if isinstance(value, Decimal):
                    converted_row.append(float(value))
                else:
                    converted_row.append(value)
            converted_rows.append(tuple(converted_row))
        
        placeholders = ','.join(['?' for _ in converted_rows[0]])
        try:
            sqlite_cursor.executemany(
                f"INSERT INTO {table_name} VALUES ({placeholders})",
                converted_rows
            )
            print(f"  ✓ Migrated {len(converted_rows)} rows")
        except Exception as e:
            print(f"  ✗ Error inserting data: {e}")

sqlite_conn.commit()
sqlite_conn.close()
mysql_conn.close()

print("\n✓ Migration completed successfully!")
print(f"SQLite database created: bike_store.db")