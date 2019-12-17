const sharp = require('sharp');

sharp('sample.bmp')
	.toFile('sample-bmp.jpg')

sharp('sample.jp2')
	.toFile('sample-jp2.jpg')

sharp('sample.jbig2')
	.toFile('sample-jbig2.jpg')
