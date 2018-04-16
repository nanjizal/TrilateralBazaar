let fs = require('fs');
let path = require('path');
let project = new Project('TrilateralKha_graphics2', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/help');
Promise.all([Project.createProject('build/help-build', __dirname), Project.createProject('/projects/NanjizalNew/hxDaedalus2/TrilateralBazaar/toolkitTest/kha', __dirname), Project.createProject('/projects/NanjizalNew/hxDaedalus2/TrilateralBazaar/toolkitTest/kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	if (fs.existsSync(path.join('/usr/local/lib/haxeLibrary/trilateral', 'korefile.js'))) {
		libs.push(Project.createProject('/usr/local/lib/haxeLibrary/trilateral', __dirname));
	}
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});
