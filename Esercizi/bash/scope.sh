g() {
	echo $x;
	x=2;  # si riferisce allo scope di f
}

f() {
	local x=3;
	g;
}

x=1
f
echo $x0