class KsItem
	attr_accessor :value, :weight, :active, :valueratio
	def initialize(value, weight)
		@weight = weight.to_i
		@value = value.to_i
		@active = false
		@valueratio = @value.to_f/@weight.to_f
	end
	def activate()
		@active = true
	end
	def deactivate()
		@active = false
	end
end