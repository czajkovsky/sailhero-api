desc 'Disactivates old alerts'

def last_activity(alert)
  last_confirmation = alert.confirmations.where(up: true).last
  return alert.created_at if last_confirmation.nil?
  [alert.created_at, last_confirmation.created_at].max
end

task check_alerts: :environment do
  puts 'Checking alerts...'
  alerts_count = 0

  Alert.all.active.each do |alert|
    in_hours = (Time.now - last_activity(alert)) / 1.hour
    if in_hours > 4.0
      alerts_count += 1
      alert.archive!
      puts "Archiving alert ##{alert.id}"
    end
  end

  puts "Removed #{alerts_count} alerts in total..."
end
