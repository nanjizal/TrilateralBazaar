let project = new Project('TrilateralKha_dotMatrixTest');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('trilateralXtra');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve( project );