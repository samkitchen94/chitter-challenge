class Peep
  attr_reader :id, :message, :sent_time

  def initialize(id:, message:, sent_time:)
    @id = id
    @message = message
    @sent_time = sent_time
  end

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end
  peeps = connection.exec("SELECT * FROM peeps ORDER BY sent_time DESC;")
  peeps.map { |peep| to_peep(peep) }
  end

  def self.create(message:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'chitter_test')
    else
      connection = PG.connect(dbname: 'chitter')
    end

  peep = connection.exec("INSERT INTO peeps (message, sent_time) VALUES('#{message}', '#{Time.now}') RETURNING id, message, sent_time;").first

  to_peep(peep)
  end

  def self.to_peep(peep_record)
    Peep.new(id: peep_record["id"], \
    message: peep_record["message"], \
    sent_time: Time.parse(peep_record["sent_time"]))
  end
end
