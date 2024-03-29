"""empty message

Revision ID: ef36fa121206
Revises: 91e20f6a57f4
Create Date: 2022-07-14 00:33:49.999519

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'ef36fa121206'
down_revision = '91e20f6a57f4'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('test_results',
    sa.Column('test_result_id', sa.Integer(), nullable=False),
    sa.Column('test_id', sa.Integer(), nullable=False),
    sa.Column('patient_id', sa.Integer(), nullable=False),
    sa.Column('submitted_at', sa.DateTime(), nullable=False),
    sa.Column('verifier_id', sa.Integer(), nullable=True),
    sa.Column('verified_at', sa.DateTime(), nullable=True),
    sa.Column('machine_report', sa.String(length=256), nullable=True),
    sa.Column('manual_report', sa.String(length=256), nullable=True),
    sa.ForeignKeyConstraint(['patient_id'], ['patients.patient_id'], ),
    sa.ForeignKeyConstraint(['test_id'], ['tests.test_id'], ),
    sa.ForeignKeyConstraint(['verifier_id'], ['psychiatrists.psychiatrist_id'], ),
    sa.PrimaryKeyConstraint('test_result_id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('test_results')
    # ### end Alembic commands ###
