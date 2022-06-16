sfdx force:data:tree:import -p /Users/raj.gonola/Documents/GitHub/Teammate/data/Product2-SBQQ__ProductFeature__c-SBQQ__ProductOption__c-plan.json -u TeamMateDev

sfdx force:data:tree:export -q /Users/raj.gonola/Documents/GitHub/Teammate/scripts/soql/productbundle.soql -d data -p

sfdx config:set defaultusername=raj.gonola@wolterskluwer.com.teammate 

sfdx config:list
