import pandas as pd
import numpy as np
import glob

path = 'C:/Users/vsgui/Documents/PythonProjects/ChamadosProject/Files' #Gives the path \ should be this /
csv_files = glob.glob(path + "/*.csv") #glob is a module Unix style pathname pattern expansion

li = [] #Create an empty matrix

for files in csv_files: #Loop over all the csv files inside the "path" variable
    df = pd.read_csv(files, index_col=None, header=0, encoding="latin-1")
    li.append(df) #Add inside this matrix all the files that were found over the loop

frame = pd.concat(li, axis=0, ignore_index=True) #Concat all the files in a single dataframe

#Selecting only the columns I want
frame = pd.DataFrame(frame, columns=['task', 'task.short_description', 'stage', 'has_breached', 'sys_created_on'])

#Renaming the columns
frame = frame.rename(columns = {'task': 'Task', 'task.short_description': 'Short Description', 'stage': 'Stage', 'has_breached': 'Has Breached SLA', 'sys_created_on': 'Created on'})

frame

#Grouping by stage and counting how many we have
group_stage = pd.DataFrame(frame, columns = ['Stage', 'Task'])
group_stage.groupby(['Stage']).count()

#Grouping by SLA and counting the percentage of False and True
group_sla = pd.DataFrame(frame, columns = ['Task', 'Has Breached SLA'])
group_sla = group_sla.rename(columns = {'Task': 'All'})

group_sla.groupby(['Has Breached SLA']).count().apply(lambda p: p / 20603).style.format("{:.2%}")

#Grouping by SLA the completed ones
completed_sla = pd.DataFrame(frame, columns = ['Stage', 'Has Breached SLA'])

completed_sla = completed_sla[completed_sla['Stage'].str.contains('Completed')==True]
completed_sla = completed_sla.rename(columns = {'Stage': 'Completed'})

completed_sla.groupby(['Has Breached SLA']).count().apply(lambda p: p / 18750).style.format("{:.2%}")

#Creating a df for all and the completed grouped by SLA

#Creating first a DataFrame for both
frm = [group_sla, completed_sla]
result = pd.concat(frm)
result = pd.DataFrame(result.groupby(['Has Breached SLA']).count())
result.columns = ['All', 'Completed']

#Getting the columns and applying the function to transform each in percentage
a = result['All'].to_frame().apply(lambda p: p / 20603)
c = result['Completed'].to_frame().apply(lambda p: p / 18750)

#Concatenating again, and presenting the Last DataFrame
frm_1 = [a, c]
rst = pd.concat(frm_1, axis=1)
rst.style.format("{:.2%}")
