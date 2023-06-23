import random

import faker.typing
from faker import Faker
from pesel import Pesel

fake = Faker()
#pesel = Pesel()

def input_firstname():
    return fake.first_name()


def input_surname():
    return fake.last_name()


def input_student_id(i):
    index =100000 + i
    return str(index)

def input_fake_pesel(i):
    pesel = 10000000000+7*i
    return str(pesel)

def input_semester_year(i):
    if i % 2 == 0:
        year = 1950 + i / 2
    else:
        year = 1950 + (i - 1) / 2
    year = int(year)
    return str(year)

def input_pesel():
    random_pesel = Pesel.generate()
    return str(random_pesel)

def input_date():
    date = fake.date()
    # date = fake.date_between('2020-01-01', '2030-01-01')
    return str(date)


def input_number(min, max):
    number = fake.random_int(min, max)
    return str(number)


def input_scholarship():
    has = fake.boolean()
    return str(has)


def input_index(i):
    index = i
    return str(index)


def input_semester_s_w(i):
    # word = fake.random_element(['Summer', 'Winter'])
    if i % 2 == 0:
        word = 'Winter'
    else:
        word = 'Summer'
    return word


def input_course_language():
    word = fake.random_element(['Polish', 'English'])
    return word


def input_student_organization_type():
    type = fake.random_element(
        ['Academic', 'Cultural', 'Faith-Based', 'Political', 'Sport', 'Special interest', 'Entertainment'])
    return type


def input_random_date():
    date = fake.random_date(1950, 2000)
    return str(date)


def input_student_organization(i):
    if i%2 ==0:
        organization = ''
    else:
        organization = input_number(1, 30)
    return str(organization)


def input_last_renovation():
    random = fake.random_element(['yes', 'no'])
    if random == 'yes':
        word = input_number(1970,2020)
    else:
        word = 'NONE'
    return str(word)

def input_classroom_type():
    type = fake.random_element(
        ['Laboratory', 'Tutorial', 'Lecture', 'Experimental', 'Special'])
    return type


def input_gastro_name(i):
    restaurants = [
        "The Hungry Bear",
        "Spicy Spoon",
        "Fresh Delight",
        "Golden Wok",
        "Rustic Table",
        "Red Pepper",
        "Savory Bites",
        "Chef's Palette",
        "Bistro 21",
        "The Foodie's Corner",
        "The Green Fork",
        "La Vida Loca",
        "Mama's Kitchen",
        "Tasty Tacos",
        "The French Connection",
        "Pizza Perfect",
        "Sizzling Steaks",
        "The Seafood Shack",
        "Wok n' Roll",
        "Burger Bliss",
        "Thai Spice",
        "The Olive Tree",
        "The Harvest Table",
        "The Garden Cafe",
        "The Meatball Shop",
        "The Grilled Cheese",
        "The Crispy Crab",
        "The Cozy Corner",
        "The Breakfast Club",
        "The Sandwich Spot",
        "The Noodle House",
        "The Taco Truck",
        "The Curry House",
        "The Dumpling Den",
        "The Falafel Factory",
        "The Tapas Bar",
        "The Sushi Train",
        "The Ramen House",
        "The BBQ Pit",
        "The Golden Loch",
        "The Cupcake Corner",
        "The Dessert Emporium"
    ]
    return str(restaurants[i])


# student
with open('Names.bulk', 'w') as file:
    for i in range(0, 200000):
       file.write(input_student_id(i+1))
       file.write('|')
       file.write(input_firstname())
       file.write('|')
       file.write(input_surname())
       file.write('|')
       file.write(input_date())
       file.write('|')
       file.write(input_fake_pesel(i))
       file.write('|')
       file.write(input_number(30, 100))
       file.write('|')
       file.write(input_number(0,1))
       file.write('|')
       file.write('1')
       file.write('|')
       file.write(input_number(2, 10))
       file.write('|')
       file.write(input_number(0, 1))
       file.write('\n')

#Semester
with open('peseltest.bulk', 'w') as file:
    for i in range(0, 2000):
        file.write(input_fake_pesel(i))
        file.write('|')
        file.write('\n')

with open('Semester.bulk', 'w') as file:
    for i in range(0, 146):
       file.write(input_index(i+1))
       file.write('|')
       file.write(input_semester_year(i+2))
       file.write('|')
       file.write(input_semester_s_w(i+2))
       file.write('|')
       file.write('0')
       file.write('|')
       file.write('0')
       file.write('\n')

#Course
with open('Course.bulk', 'w') as file:
    for i in range(0, 45):
       file.write(input_index(i+1))
       file.write('|')
       file.write(input_course_language())
       file.write('|')
       file.write(input_number(1950, 2012))
       file.write('\n')


#StudentOrganization
with open('StudentOrganization.bulk', 'w') as file:
    for i in range(0, 30):
        file.write(input_index(i + 1))
        file.write('|')
        file.write(input_student_organization_type())
        file.write('|')
        file.write(input_number(1, 8))
        file.write('\n')


#Department
with open('Department.bulk', 'w') as file:
    for i in range(0, 8):
        file.write(input_index(i + 1))
        file.write('|')
        file.write(input_number(0, 1))
        file.write('|')
        file.write(input_number(1, 8))
        file.write('|')
        file.write(input_number(0, 1))
        file.write('|')
        file.write(input_number(0, 3))
        file.write('|')
        file.write(input_number(0, 3))
        file.write('|')
        file.write(input_number(0, 100))
        file.write('%')
        file.write('\n')


#test
with open('test.txt', 'w') as file:
    for i in range(0, 10):
        file.write(input_random_date())
        file.write('\n')


# BelongStudentOrganization
with open('BelongStudentOrganizationMORE.bulk', 'w') as file:
    for i in range(200000, 200005):
        file.write((input_index(i + 1)))
        file.write('|')
        file.write(input_student_id(i+1))
        file.write('|')
        file.write(input_student_organization(i))
        file.write('\n')

# Building
with open('Building.bulk', 'w') as file:
    for i in range(1, 30):
        file.write((input_index(i)))
        file.write('|')
        file.write(input_number(500, 1500))
        file.write('|')
        file.write(input_number(3, 9))
        file.write('|')
        file.write(input_last_renovation())
        file.write('|')
        file.write(input_number(1500, 9000))
        file.write('\n')
#classroom

with open('Classroom.bulk', 'w') as file:
    for i in range(1, 1500):
        file.write((input_index(i)))
        file.write('|')
        file.write(input_number(15, 30))
        file.write('|')
        file.write(input_scholarship())
        file.write('|')
        file.write(input_number(20, 45))
        file.write('|')
        file.write(input_classroom_type())
        file.write('|')
        file.write(input_number(1, 30))
        file.write('\n')



#gastronomy
with open('Gastronomy.bulk', 'w') as file:
    for i in range(1, 40):
        file.write((input_index(i)))
        file.write('|')
        file.write(input_gastro_name(i))
        file.write('|')
        file.write(input_surname())
        file.write('|')
        file.write(input_number(1, 30))
        file.write('\n')



#classes
with open('Classes.bulk', 'w') as file:
    for i in range(1, 450):
        file.write((input_index(i)))
        file.write('|')
        file.write(input_number(1,8))
        file.write('|')
        file.write(input_number(1,30))
        file.write('|')
        file.write(input_number(1, 46))
        file.write('\n')
        

with open('Classes.bulk', 'w') as file:
    for i in range(1, 450):
        file.write((input_index(i)))
        file.write('|')
        file.write(input_number(1,8))
        file.write('|')
        file.write(input_number(1,30))
        file.write('\n')  


k = 0
with open('IsOnCourseSemester.bulk', 'w') as file:
    for i in range(1, 200001):
        number = random.randint(1, 7)
        number2 = random.randint(1, 139)
        for j in range(1, number):
            k = k + 1
            index = str(k)
            file.write(index)
            file.write('|')
            file.write(input_number(1,45))
            file.write('|')
            semester = str(number2+j)
            file.write(semester)
            file.write('|')
            file.write(input_student_id(i))
            file.write('|')
            file.write(input_number(1, 8))
            file.write('|')
            file.write(input_fake_pesel(i-1))
            file.write('\n')
