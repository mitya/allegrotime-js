namespace :data do
  task :import do
    csv_file  = "assets/data/schedule_20180625.csv"
    date = '2018-06-27'
    trains_count = 20

    data = CSV.read(csv_file, col_sep: ';')
    headers = data.shift
    weekday_info = data.shift
    allegro_info = data.shift

    trains_numbers = []
    train_rules = {}
    trains_count.times do |index|
      index = index + 1
      csv_index = index + 3
      base_train_number = index <= trains_count / 2 ? index * 2 : (index - trains_count / 2) * 2 - 1
      train_number = (allegro_info[csv_index] == 'А' ? 700 : 7500) + base_train_number
      trains_numbers << train_number
      train_rules[train_number] = weekday_info[csv_index] if weekday_info[csv_index]
    end

    dataset = {}
    dataset['alert'] = nil
    dataset['updated_at'] = date
    dataset['trains'] = trains_numbers
    dataset['train_rules'] = train_rules

    data.reject! { |r| r[0] == 'Поклонногорская' }

    dataset['crossings'] = data.map do |row|
      {
        name: row[0],
        distance: row[1].to_i,
        lat: row[2].to_f,
        lng: row[3].to_f,
        updated_at: row[4 + trains_count],
        closings: row[4, trains_count]
      }
    end


    dataset_v1 = {}
    dataset_v1['alert'] = nil
    dataset_v1['updated_at'] = date
    dataset_v1['trains'] = trains_numbers
    dataset_v1['rows'] = data.map do |row|
      row[1] = row[1].to_i
      row[2] = row[2].to_f
      row[3] = row[3].to_f
      row
    end

    File.write "assets/data/schedule.json", JSON.pretty_generate(dataset_v1)
    File.write "assets/data/schedule_v2.json", JSON.pretty_generate(dataset)
    File.write "assets/data/schedule_timestamp.json", JSON.pretty_generate(updated_at: date)
    File.write "src/models/data.js", "module.exports = #{JSON.pretty_generate(dataset)}"
  end

  task :copy_to_site do
    cp "assets/data/schedule.json", "../site/source/data/"
    cp "assets/data/schedule_v2.json", "../site/source/data/"
    cp "assets/data/schedule_timestamp.json", "../site/source/data/"
  end

  task :convert_tabs do
    input = "811 1040 1411 1426 1620 1926 1949 2201 2326 646 815 1045 1531 1545 1825 2031 2055"
    output = input.gsub(' ', "\t").gsub(/(\d?\d)(\d\d)/, '\1:\2')
    puts output
  end
end
