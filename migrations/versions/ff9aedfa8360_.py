"""empty message

Revision ID: ff9aedfa8360
Revises: 7b85be8a6f99
Create Date: 2022-07-14 00:08:29.863505

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = 'ff9aedfa8360'
down_revision = '7b85be8a6f99'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('tests', 'name',
               existing_type=sa.VARCHAR(length=64),
               nullable=False)
    op.alter_column('tests', 'created_at',
               existing_type=postgresql.TIMESTAMP(),
               nullable=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column('tests', 'created_at',
               existing_type=postgresql.TIMESTAMP(),
               nullable=True)
    op.alter_column('tests', 'name',
               existing_type=sa.VARCHAR(length=64),
               nullable=True)
    # ### end Alembic commands ###
