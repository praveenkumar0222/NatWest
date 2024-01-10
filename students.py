import csv
def analyze_student_grades(file_path, threshold):
    above_threshold_students = []
    
    with open(file_path, 'r') as csvfile:
        csvreader = csv.DictReader(csvfile)
        for row in csvreader:
            name = row['name']
            grades = [int(row['grade']) for row in csvreader if row['name'] == name]
            avg_grade = sum(grades) / len(grades) if grades else 0
            if avg_grade > threshold:
                above_threshold_students.append(name)
    
    print(f"Students with an average grade above {threshold}:")
    for student in above_threshold_students:
        print(student)
file_path = 'students.csv'

threshold_grade = 80
analyze_student_grades(file_path, threshold_grade)




# Replace 'students.csv' with the path to your CSV file containing student information in the format (name, age, grade). Also, adjust the threshold_grade variable to set the desired threshold for the average grade.

# Run these scripts in your Python environment after installing the boto3 library using pip install boto3 for the AWS SDK interaction. Adjust the file paths, bucket names, and thresholds as needed for your specific use case.
