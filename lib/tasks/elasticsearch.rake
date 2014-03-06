namespace :elasticsearch do
  namespace :rebuild do
    models = %w{star}

    models.each do |model|
      desc "Recreates indicies for #{model.titleize}"
      task model => :environment do
        model_klass = model.camelize.constantize
        model_klass.__elasticsearch__.client.indices.delete index: model_klass.index_name rescue nil
        model_klass.__elasticsearch__.create_index! force: true
        model_klass.eager_import
      end
    end

    desc "Recreates indicies for all models"
    task :all => models
  end
end
