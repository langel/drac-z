const fs = require('fs');



/*
	room data packed like:
		24 bytes - name
		 8 bytes - clockwise nets
*/
let room_data = require('./room_data.json');
let room_count = Object.keys(room_data).length;
console.log(room_count + ' rooms');
let binary = new Uint8Array(room_count * 32);
let p = 0; // pointer
const directions = ["no","ne","ea","se","so","sw","we","nw"];

for (const [i, room] of Object.entries(room_data)) {
	console.log(room.name);
	p = i*32;
	for (const chr of room.name) {
		binary[p] = chr.charCodeAt(0);
		p++;
	}
	p = i*32 + 24;
	for (const [j, dir] of directions.entries()) {
		console.log(room.net + ' ' + dir);
		if (Object.hasOwn(room.net, dir)) {
			binary[p] = room.net[dir];
			console.log('dir found');
		}
		else binary[p] = 0xff;
		p++;
	}
}

fs.writeFile('room_data.bin', Buffer.from(binary), (err) => {
	if (err) console.log(err);
});
