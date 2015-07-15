class Occurrence < ActiveRecord::Base
	connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")
	
	self.table_name="mgd.v_minloc"
	#bad_attribute_names :class
	#set_table_name "mgd.occurrences"
	ignore_table_columns :class
	self.primary_key=:minlocno
	
	def self.state(state)
		where(state: state)
	end

end