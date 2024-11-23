from pyhive import hive

def connect_to_hive(host='localhost', port=10000, database='default'):
    """
    Connect to Hive with explicit host, port, and database
    
    Args:
        host (str): Hive server hostname
        port (int): Hive server port
        database (str): Target database name
    
    Returns:
        hive.Connection: Hive connection object
    """
    conn = hive.Connection(
        host=host,
        port=port,
        database=database
    )
    
    return conn

# Example usage
try:
    connection = connect_to_hive(
        host='localhost', 
        port=10000, 
        database='default'  # Specify default or your database name
    )
    
    cursor = connection.cursor()
    
    # Example query
    cursor.execute("SHOW databases")
    results = cursor.fetchall()
    print(results)
    
except Exception as e:
    print(f"Connection error: {e}")
finally:
    if 'connection' in locals() and connection:
        connection.close()