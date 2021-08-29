##NYU exercises
import pandas as pd
import numpy as np


data = [['A1', 28], ['A2', 32], ['A3', 1], ['A4', 0],
        ['A5', 10], ['A6', 22], ['A7', 30], ['A8', 19],
		['B1', 145], ['B2', 27], ['B3', 36], ['B4', 25],
		['B5', 9], ['B6', 38], ['B7', 21], ['B8', 12],
		['C1', 122], ['C2', 87], ['C3', 36], ['C4', 3],
		['D1', 0], ['D2', 5], ['D3', 55], ['D4', 62],
		['D5', 98], ['D6', 32]]
		
# 1 - How many sites are there?

df = pd.DataFrame(data, columns=['Site', 'Number'])
df
index = df.index
number_of_sites = len(index)
print(number_of_sites)

#Answer = 26 sites

# 2 - How many birds were counted at the 7th site?

birds_7th = df['Number']
birds_7th[index[6]]

#Answer = 30 counted at the 7th site

# 3 - How many birds were counted at the last site?

#To select the last row of dataframe using iloc[], we can just skip the column section 
#and in row section pass the -1 as row number. Based on negative indexing, 
#it will select the last row of the dataframe

birds_last = df.iloc[-1]
print(birds_last['Number'])

#Answer = 32 birds at the last site

# 4 - What is the total number of birds counted across all sites?

#Use the DataFrame.sum() function for that
#Basic Structure: sum = df['Axis'].sum()

total = df['Number'].sum()
total

#Answer = 955

# 5 - What is the average number of birds seen on a site?

#We use the same concept as to sum
#Average function: mean = df['Axis'].mean()

mean = df['Number'].mean()
#Convert to integer since we can't have 36.73 birds
print(int(mean))

#Answer = 36 birds

# 6 - What is the total number of birds counted on sites with codes beginning with C?

#We use the str.startswith() function
#Structure: df['Axis'].str.startswith('element')

birds_in_c = df[df['Site'].str.startswith('C')]
total_c = birds_in_c['Number'].sum()
total_c

#Answer = 248 birds in Sites C