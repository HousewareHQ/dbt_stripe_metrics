import glob

def sql_updater(): 

    list_of_files = glob.glob('./' + '/**/*.sql', recursive=True)           # create the list of file
    for file in list_of_files:
            file_path = file.replace('.sql','')
            file = file.replace('.sql','')
            file = file[file.rfind('/') + 1:]

            with open("%s.sql"%file_path, "r+") as text_file:
                f = text_file.read()

                f = f.replace("metrics.metric","metrics.calculate")
                f = f.replace("metric_name=\'%s\'"%file, "metric(\'%s\')"%file)

                text_file.seek(0)
                text_file.write(f)
                text_file.truncate()


    with open("..//..//packages.yml","r+") as text_file_2:
        f2 = text_file_2.read()
        text_file_2.seek(0)
        text_file_2.write(f2.replace("version: 0.3.5","version: 1.3.0") )


def yml_updater():

    list_of_files = glob.glob('./' + '/**/*.yml', recursive=True) 
    for file in list_of_files:
        file_path = file.replace('.yml','') #storing the file path
        file = file.replace('.yml','') #trimming the extension
        file = file[file.rfind('/') + 1:] #stripping of the trailing slashes
        
        with open("%s.yml"%file_path, "r+") as text_file:
                    f = text_file.read()

                    f = f.replace("type","calculation_method")
                    f = f.replace("sql","expression")
                    
                    text_file.seek(0)
                    text_file.write(f)
                    text_file.truncate()
    

sql_updater()
yml_updater()
