# Central rgister of services on CULS

SOAP services for all important information which are created or consumed by
other systems on university.

WSDL: http://services.czu.cz/CULSServices?wsdl

## Services

### **Structure**

* **getFaculties** - all faculties on university

  * id
  * name
  * name_english
  * short_name
  * code
  * ldap_context

* **getDepartments** - all departments

  * id
  * name
  * name_english
  * short_name
  * code
  * faculty_id
  * department_type_id

### **Personal info**

* **getEmploee** - employee by **uic**

  * uic
  * first_name
  * last_name
  * birth_name
  * title_before
  * title_after
  * email
  * phone_line
  * department_code

* **getEmployees** - all employees

  * same as getEmployee in collection

* **getPhoto** - photo by **uic**

  * uic
  * cdata
  * format
  * type

### **Study**

* **getSubject** - subject by **code**

  * id
  * code
  * name
  * name_english
  * guarantee_uic

* **getSubjectsFor** - all subjects for employee by **uic**

  * same as for getSubject in collection

* **getSpecializations** - all study specializations

  * id
  * code
  * short_name
  * name
  * name_english
  * guarantee_uic

* **getPrograms** - all study programs

  * id
  * code
  * name
  * name_english
  * guarantee_uic

* **getStudyStatuses** - all study statuses

  * code
  * name
  * name_english

* **getStudyForms** - all study forms

  * code
  * name
  * name_english

* **getStudyLevels** - all study levels

  * code
  * name
  * name_english

* **getEducations** - all education types

  * code
  * name
  * name_english

### **Science**

* **getPublication** - all publications for uic of eployer

  * id
  * name
  * name_english
  * publication_year
  * authors
  * quotations
  * publication_type
  * cep

* **getGrants** - all grants

  * id
  * guarantee_uic
  * name
  * name_english
  * finance
  * year_from
  * year_to
  * provider_code
  * provider_name

* **getGrant** - grant for uic

  * id
  * guarantee_uic
  * name
  * name_english
  * finance
  * year_from
  * year_to
  * provider_code
  * provider_name

### **General**

* **getCountries** - all countries in the world

  * code
  * name
  * name_english

* **getCitizenshipTypes** - all citizenship types

  * code
  * name
  * name_english

* **getPaymentTypes** - all payment types

  * code
  * name

* **getMunipalities** - all czech municipalities

  * code
  * name

* **getZips** - all czech zips with municipalities

  * zip
  * name
  * name_english

* **getMaritalStatuses** - all marital statuses

  * code
  * name
  * name_english

* **getGenders** - both genders :)

  * code
  * name
  * name_english

