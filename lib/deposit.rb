class Deposit < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

	self.table_name="mgd.deposits"
	self.primary_key=:eno
	
	def self.state(state)
		where(state: state)
	end

end