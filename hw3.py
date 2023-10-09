import psycopg2 as pg
import argparse as ap

conn = None

def list_all_countries():
    cur = conn.cursor()
    cur.execute('SELECT * FROM countries;')
    print(cur.fetchall())
    cur.close()
    return

def select_cities(postal, country, name):
    cur = conn.cursor()
    if not(postal or country or name):
        print("Missing selector flags. Please refer to the README for function execution.")

    # check whether postal, country code, and name are filled
    # SELECT * based on that
    execution_string = "SELECT * FROM cities WHERE "
    if postal:
        execution_string + "postal_code=" + postal
        if (country or name):
            execution_string + " AND "
    if country:
        execution_string + "country_code=" + country
        if name:
            execution_string + " AND "
    if name:
        execution_string + "name=" + name
    execution_string + ";"

    cur.execute(execution_string)
    cur.close()
    return

def add_new_city(postal, country, name):
    cur = conn.cursor()

    if not(postal and country and name):
        print("Need ALL of the flags (-p, -c, -n) for city creation. Please refer to the README for function execution.")

    # have arguments for the user to input what the name, postal code, and country code will be
    # execute insert command
    execution_string = "INSERT INTO cities (name, postal_code, country_code) VALUES (" + name + ", " + postal + ", " + country + ");"
    cur.execute(execution_string)

    cur.close()
    return

def update_city_attributes(name, change, value):
    cur = conn.cursor()
    if not(name and change and value):
        print("Need ALL of the flags (-n, -ch, -v) for city attribute update. Please refer to the README for function execution.")

    # take argument having whatever attributes they wanna update
    # execute update command
    execution_string = "UPDATE cities SET " + change + " = " + value + " WHERE name=" + name
    cur.execute(execution_string)

    cur.close()
    return

def delete_city(name):
    cur = conn.cursor()
    cur.execute("DELETE FROM cities WHERE name=" + name)
    cur.close()
    return

if __name__ == '__main__':
    parser = ap.ArgumentParser(
                    prog='HW3 PostgreSQL CLI',
                    description='Provides functionality to interact with the demo PostgreSQL database for ECE:5845.',
                    epilog='More details on the program can be found in the README.')

    # Create arguments for CLI
    parser.add_argument("function", dest='f', required=True)
    parser.add_argument("-p", "--postal_code", dest='p', required=False)
    parser.add_argument("-c", "--country_code", dest='c', required=False)
    parser.add_argument("-n", "--name", dest='n', required=False)
    parser.add_argument("-ch", "--change", dest='ch', required=False)
    parser.add_argument("-v", "--value", dest='v', required=False)

    args = parser.parse_args()

    # Establish database connection.
    try:
        file = open("credentials.txt")
        file_content = file.readlines()

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        conn = pg.connect(
            host="s-l112.engr.uiowa.edu",
            port=5432,
            database="mdb_student37",
            user=file_content[0],
            password=file_content[1])
		
        # create a cursor
        cur = conn.cursor()
        
	    # execute a statement
        print('Successfully connected to the PostgreSQL database.')
        print('PostgreSQL database version:')
        cur.execute('SELECT version();')

        # display the PostgreSQL database server version
        db_version = cur.fetchone()
        print(db_version)
        cur.close()

        # Based on the function the user wants to run, execute respective method.
        match args.f:
            case "list_all_countries":
                print('Executing -> List all countries.')
                list_all_countries()
            case "select_cities":
                print('Executing -> Select cities.')
                select_cities(args.p, args.c, args.n)
            case "add_new_city":
                print('Executing -> Add new city.')
                add_new_city(args.p, args.c, args.n)
            case "update_city_attributes":
                print('Executing -> Update city attributes.')
                update_city_attributes(args.n, args.ch, args.v)
            case "delete_city":
                print('Executing -> Delete city.')
                delete_city(args.n)

    except (Exception, pg.DatabaseError) as error:
        print("Something went wrong. Here's the error:")
        print(error)
        print()
        print("Press the UP ARROW followed by ENTER on your keyboard to re-enter your previous query, otherwise enter a new query manually.")

    # close the communication with the PostgreSQL
    if conn is not None:
        conn.close()
        print('Database connection closed.')