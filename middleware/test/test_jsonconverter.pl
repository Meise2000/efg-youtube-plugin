use Test::More tests => 23;

use lib '.'; 
require 'jsonconverter.pm';

# null values
is(jsonconverter::toJson(), 'null', "no param should be 'null'");
is(jsonconverter::toJson(undef), 'null', "undef should be 'null'");

# numeric values
is(jsonconverter::toJson(123), '123', "Simple numeric value should be untouched");
is(jsonconverter::toJson(123.45), '123.45', "Numeric with fraction value should be untouched");
is(jsonconverter::toJson(-123), '-123', "Negative numeric value should be untouched");
is(jsonconverter::toJson(-123.45), '-123.45', "Negative numeric with fraction value should be untouched");

# boolean values
is(jsonconverter::toJson('true'), 'true', "true should be untouched");
is(jsonconverter::toJson('false'), 'false', "false should be untouched");

# string values
is(jsonconverter::toJson('Pommes'), '"Pommes"', "A string should be surrounded by quotes");
is(jsonconverter::toJson('Pom"mes'), '"Pom\\"mes"', "A string with double quotes should be escaped");
is(jsonconverter::toJson('Po"mm"es'), '"Po\\"mm\\"es"', "A string with many double quotes should be escaped");

# array values
is(jsonconverter::toJson([1,2,3]), '[1,2,3]', "a numeric array should be unquoted");
is(jsonconverter::toJson([undef,undef]), '[null,null]', "a null array should be unquoted");
is(jsonconverter::toJson(['true','false']), '[true,false]', "a boolean array should be unquoted");
is(jsonconverter::toJson(["Pommes","Ma\"jo"]), '["Pommes","Ma\\"jo"]', "a string array should be quoted correctly");
is(jsonconverter::toJson([1,'true',"Pommes",undef]), '[1,true,"Pommes",null]', "a mixed array should be quoted for strings only");

# hash values
is(jsonconverter::toJson({'key' => 123}), '{"key":123}', "a hash with one numeric value should be unquoted");
is(jsonconverter::toJson({'key' => 'true'}), '{"key":true}', "a hash with one boolean value should be unquoted");
is(jsonconverter::toJson({'key' => "Pommes"}), '{"key":"Pommes"}', "a hash with one numeric value should be unquoted");
is(jsonconverter::toJson({'key' => undef}), '{"key":null}', "a hash with one undefined value should be unquoted");
is(jsonconverter::toJson({'key' => [1,'true',"Pommes",undef]}), '{"key":[1,true,"Pommes",null]}', "a hash with one array value should be unquoted");
is(jsonconverter::toJson({'key1' => 1, 'key2' => 'true', 'key3' => "Pommes", 'key4' => undef}), '{"key1":1,"key2":true,"key3":"Pommes","key4":null}', "a hash with many keys should be unquoted");

# complex value
is(jsonconverter::toJson([{'key1' => 1, 'key2' => 'Pommes'}, {'key1' => 4, 'key2' => 'Majo'}]), '[{"key1":1,"key2":"Pommes"},{"key1":4,"key2":"Majo"}]', "convert a complex value");