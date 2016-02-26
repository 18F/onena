require 'spec_helper'
require 'onena'

describe Onena::Util do
	let(:tock_list) { ['first', 'second', 'third'] }
	let(:float_list) { ['first', 'secnd', 'third one'] }

	context '#matches' do
		it 'should exclude exact matches' do
			matches = Onena::Util.matches(tock_list: tock_list, float_list: float_list)
			tock_items = matches.map { |match| match[:tock] }.uniq
			expect(tock_items).not_to include('first')
			float_items = matches.map { |match| match[:float] }.uniq
			expect(float_items).not_to include('first')
		end

		it 'should include all non-exact matches' do
			matches = Onena::Util.matches(tock_list: tock_list, float_list: float_list)
			expect(matches.length).to eq(4)
			expect(matches).to include({ :tock => 'third', :float => 'third one', :distance => 4, :similarity => 0.8 })
		end
	end

end
