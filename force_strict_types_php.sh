#!/bin/bash

echo "The affected files will be:"
grep -R --include="*.php"  "<?php" . |  awk '{print $1 }' FS=":" 
 

# Change to strict types
grep -R --include="*.php"  "<?php" . |  awk '{print $1 }' FS=":"  | xargs sed -i 's/declare(strict_types=1);//g'
grep -R --include="*.php"  "<?php" . |  awk '{print $1 }' FS=":"  | xargs sed -i 's/declare(strict_types = 1);//g' 
grep -R --include="*.php"  "<?php" . |  awk '{print $1 }' FS=":"   | xargs sed -i 's/<?php/<?php\n\ndeclare(strict_types=1);/g'
echo "Done"
