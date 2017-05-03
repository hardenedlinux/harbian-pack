. build_system/do_make_repo/do_make_repo.conf.sh

# Copy packages
rm -rf repo/
for i in out/deb/*.deb
do
	bn="`basename $i`"
	fl="`echo $bn | cut -c 1`"
	mkdir -p repo/$fl
	cp "$i" repo/$fl/
done

# Scan packages
pushd repo
dpkg-scanpackages . > Packages
popd

# Generate "Release" file
cat > repo/Release << EOF
Origin: $origin
Label: $label
Suite: $suite
Codename: $codename
Date: `date -u -R`
Valid-Until: `date -u -R --date="$valid_until"`
Architectures: `dpkg --print-architecture`
Description: $description
EOF
pushd repo
echo SHA256: >> Release
printf ' ' >> ./Release
echo `sha256sum ./Packages | cut -f 1 -d ' ' ` `du -b Packages` >> ./Release
popd

# Sign "Release" file
gpg --batch -a -b -abz3 --digest-algo SHA512 -o repo/Release.gpg --sign repo/Release
