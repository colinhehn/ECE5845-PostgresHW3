## ECE:5845 Modern Databases HW3
Here's my PostgreSQL & Python CLI for our Homework 3 assignment. Instructions for operation can be found below.

### Instructions:
1. In database.ini, fill in the username and password with your own credentials. These credentials will be inputted into the program on runtime to connect to the PostgreSQL database.
2. Running the CLI
   1. The program can be run from the command line with "python hw3.py [ARGUMENTS]" when cd'd into the same directory as the file.
   2. The arguments to execute each function are as follows:
      1. FUNCTION -> The first argument is which function you want to run. A list of functions can be found in the next README section below.
      2. FLAGS -> using -p, -c, or -n allows you to specify what parameters should be put into said function. These aren't required for all of them, and you can see how they're used for each specific function below.
      3. A correct use of the format looks like this *"python hw3.py select_cities -n Chicago"*
3. Parameters for each function
   1. List all the countries
      1. "python hw3.py list_all_countries"
      2. No flags for this one, just displays the countries.
   2. Search for cities
      1. "python hw3.py select_cities -n Chicago -p 12345"
      2. Can use -n (name), -p (postal code), or -c (country code) interchangeably to select certain cities based on those values.
   3. Add a new city
      1. "python hw3.py add_new_city -n "Some Name" -p 44444 -c us
      2. This one you NEED to have all 3 of the flags filled in, otherwise it will not work.
   4. Update city attributes
      1. "python hw3.py update_city_attributes -n "Some Name" -ch name -v Minneapolis"
      2. This one takes the -n NAME flag to identify a row to change, then uses the -ch CHANGE flag to identify which attribute of the city to change (name, postal_code, or country_code), and finally the -v VALUE flag indicates what you want the value of this new attribute to be.
   5. Delete a city
      1. "python hw3.py delete_city -n name"
      2. This one ONLY takes the name field, and deletes whichever city in the database matches the name in the input.