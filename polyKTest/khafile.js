let project = new Project('TrilateralKha_graphics2');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('hxPolyK');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;

resolve( project );