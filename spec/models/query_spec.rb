# frozen_string_literal: true

require 'rails_helper'

describe 'Query' do
  context '::create' do
    context 'when the token parameter is nil' do
      context 'successful' do
        subject {Query.create(institution_name: 'UGA', report_type: 'New Titles')}
        it 'has the correct path' do
          expect(subject[:path]).to match('/shared/UGA/Reports/New Titles')
        end
        it 'does not have token key' do
          expect(subject[:token]).to be_nil
        end
      end
      context'unsuccessful' do
        it 'raises an error when parameter institution_name is nil' do
          expect { Query.create(report_type: 'New Titles') }
            .to raise_error(ArgumentError, /institution_name/)
        end
        it 'raises an error when parameter report_type is nil' do
          expect { Query.create(institution_name: 'UGA') }
            .to raise_error(ArgumentError, /report_type/)
        end
      end
    end
    context 'when token is supplied' do
      subject {Query.create(institution_name: 'UGA', report_type: 'New Titles', token: '100')}
      it 'has the correct token value' do
        expect(subject[:token]).to match('100')
      end
      it 'does not have path key' do
        expect(subject[:path]).to be_nil
      end
    end
    context 'when path is supplied' do
      it 'has the the correct path value' do
      path = 'test/path'
      query = Query.create(institution_name: 'UGA',
                           report_type: 'New Titles',
                           path: path)
      expect(query[:path]).to match(path)
      end
    end
    context 'when path is not supplied' do
      it 'has the the correct path value' do
        institution = 'test institution'
        report = 'test report'
        query = Query.create(institution_name: institution,
                             report_type: report)
        path = "/shared/#{institution}/Reports/#{report}"

        expect(query[:path]).to match(path)
      end
    end
  end
end