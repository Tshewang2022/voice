/*
  Warnings:

  - A unique constraint covering the columns `[phone]` on the table `ContactList` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "ContactList_phone_key" ON "public"."ContactList"("phone");
