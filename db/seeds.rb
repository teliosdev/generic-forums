# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

seed_data = Hashie::Mash.new(
  YAML::load_file(Rails.root.join('db', 'seeds.yml'))
)

def seed_model(key, model_data)
  model_class = key.classify.constantize

  model_data.data.each do |set|
    model = model_class.new(set.to_hash)
    model.save(validate: false)
  end
end

def seed_relationship(key, relation)
  class_names = [relation.left.classify, relation.right.classify]
  left_class, right_class = class_names.map(&:constantize)
  keys = class_names.map(&:foreign_key)

  relation.data.each do |set|
    inst = left_class.find(set[keys[0]])
    inst.send(relation.right) << right_class.find(set[keys[1]])
  end
end

ActiveRecord::Base.transaction do
  seed_data.each do |k, v|
    case v.type
    when "model"
      seed_model(k, v)
    when "relationship"
      seed_relationship(k, v)
    else
      $stderr.puts("I don't know how to handle #{v.type}!")
    end
  end
end
