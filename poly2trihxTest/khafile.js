let project = new Project('TrilateralKha_poly2trihxTest');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('hxPolyK');
project.addLibrary('poly2trihx')
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve( project );