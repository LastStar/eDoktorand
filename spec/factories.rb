Factory.define :user do |u|
  u.login 'anonymous'
end

Factory.define :coridor do |c|
  c.name 'coridor'
  c.name_english 'en coridor'
  c.code 'COR'
  c.association :faculty, :factory => :faculty
end

Factory.define :faculty do |f|
  f.name 'faculty'
  f.name_english 'en faculty'
  f.short_name 'FAC'
end
